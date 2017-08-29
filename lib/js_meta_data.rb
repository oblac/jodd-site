require 'nokogiri'
require 'json'
require 'fileutils'

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
    print ("Generating JS search data...\n")
    # Extract parameters
    items       = params.fetch(:items) { @items.reject { |i| i[:is_hidden] } }
    select_proc = params.fetch(:rep_select, nil)

    # Create builder
    buffer = "["
    count = 0

    # Build sitemap
    # Add item
    items.sort_by(&:identifier).each do |item|
      reps = item.reps.select(&:path)
      reps.select! { |r| select_proc[r] } if select_proc
      reps.sort_by { |r| r.name.to_s }.each do |rep|
        if (rep.path).end_with?(".html")

          begin
            content = File.read("output" + rep.path)
          rescue SystemCallError
            print ("\tSkipped " + rep.path)
            return
          end
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

          json = {"t" => document[:title],"v" => words,"u"=>@item[:site_path]}

          if count != 0
            buffer = buffer + ','
          end
          count += 1
          buffer = buffer + JSON.pretty_generate(json)
        end
      end
    end

    # Return data
    buffer = buffer + "]"
    buffer
  end
end

include JoddJsMeta