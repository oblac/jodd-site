require 'nokogiri'
require 'json'
require 'kramdown'

module JoddJsMeta

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


  def js_meta_data(params = {})
    print ("Generating JS meta-data...\n")
    # Extract parameters
    items       = params.fetch(:items) { @items.reject { |i| i[:is_hidden] } }

    buffer = "["
    count = 0

    items.sort_by(&:identifier).each do |item|

      itemIdentifier = item.identifier.to_s

      if (["/401.md","/402.md","/403.md","/404.md","/400.md","/500.md"].include? itemIdentifier)
        next
      end

      if (itemIdentifier).end_with?(".md")
        content = item.raw_content
        html = Kramdown::Document.new(content).to_html
        html = Nokogiri::HTML(html)

        document = {
          :title => item[:title]? item[:title] : 'Jodd',
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

        json = {"t" => document[:title],"v" => words,"u"=>item[:site_path]}

        if count != 0
          buffer = buffer + ','
        end
        count += 1
        buffer = buffer + JSON.pretty_generate(json)
      end
    end

    # Return data
    buffer = buffer + "]"
    buffer
  end
end

include JoddJsMeta