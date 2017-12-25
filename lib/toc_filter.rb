module Toc

  # TODO document
  class AddTOCFilter < Nanoc::Filter
    identifier :add_toc

    def run(content, params={})
      if (@item[:toc] == false)
        return content.gsub('{{TOC}}', '')
      end

      content.gsub('{{TOC}}') do
        # Find all top-level sections
        doc = Nokogiri::HTML(content)
        #headers = doc.xpath('//article//*[self::h2 or self::h3]').map do |header|
        headers = doc.xpath('//article//*[self::h2]').map do |header|
          { :title => header.inner_html,
            :id => header['id'],
            :name => header.name
          }
        end

        if headers.empty?
          next ''
        end

        # Build table of contents
        res = %[<div id="toc"><div id="xtoc"><h2>Page Content&nbsp;&nbsp;<i class="fa fa-file-text-o"></i></h2>\n<ul class="toc-1">]
        headers.each do |header|
          res << %[<li class="toc-#{header[:name]}"><a href="##{header[:id]}">#{header[:title]}</a></li>]
        end
        res << '</ul></div></div>'

        res
      end
    end

  end

end