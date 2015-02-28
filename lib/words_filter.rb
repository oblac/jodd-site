require 'nokogiri'
require 'json'
require 'fileutils'

class WordsFilter < Nanoc::Filter
  identifier :words_filter
  type :text

  def initialize(hash = {})
    super

    @index_file = 'output/js/data.json'
    @index_file = File.join(
        @site.config[:output_dir],
        @site.config[:js_search_file] || 'js/data.json')
  end

  def word_counter(string, max)
    string.split(/\s+/)
          .select { |x| x.length() > 3}
          .group_by{|x|x}
          .map{|x,y|[x,y.size]}
          .sort_by{|_,size| -size}
          .first(max)
  end

  def extract_text(html, path)
    tokens = html.xpath(path).to_a.map { |t|
      t.content.gsub('\r', ' ').gsub('\n', ' ').squeeze(' ').strip
    }.reject! { |t|
      t.empty?
    }

    (tokens || []).join(' ')
  end

  def extract_text2(html, path)
    tokens = html.xpath(path).to_a.map { |t|
      t.to_s().gsub('\r', ' ').gsub('\n', ' ').squeeze(' ').strip
    }

    (tokens || []).join(' ')
  end

  def run(content, params={})
    html = Nokogiri::HTML(content)

    document = {
      :title => @item[:title]? @item[:title] : 'Jodd',
      :alltitles => extract_text2(html, '//*[self::h1 or self::h2]/text()'),
      :body => extract_text(html, '//*/text()'),
    }

    text = document[:body] <<
            ' ' << document[:title] <<
            ' ' << document[:title] <<
            ' ' << document[:title] <<
            ' ' << document[:title] <<
            ' ' << document[:title] <<
            ' ' << document[:alltitles] <<
            ' ' << document[:alltitles]

    words = word_counter(text, 15)
    words = words.map{|e| e[0] }.join(' ')

    # update

    filename = @site.config[:output_dir] + '/.meta' + @item[:site_path] + '.json'
    dirname = File.dirname(filename)
    unless File.directory?(dirname)
      FileUtils.mkdir_p(dirname)
    end

    puts("\t" + filename)

    File.open(filename, 'w') do |file|
      json = {"t" => document[:title],"v" => words,"u"=>@item[:site_path]}

      file.write(JSON.pretty_generate(json))
    end

    content
  end
end
