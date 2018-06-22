# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.

module JoddDocs
	require 'nanoc/helpers/html_escape'
    include Nanoc::Helpers::HTMLEscape

    # Returns item path
	def path(item)
		item[:site_path]
	end

	# Collect paths
	def collect_path(item)
		#puts item.raw_filename

		path = item.identifier.to_s

		# remove raw prefix
		if (path.start_with?('/static/'))
			path = path[7..-1]
		end

		# puts "---->" + path

		# collect documents (format: /path/number+name.md)
		ndx = path.index('+')
		if (ndx != nil)
			last = path.rindex('/')
			key = path[0..last]
			number = path[(last+1)..(ndx-1)]
			path = key + path[(ndx+1)..-1]

			add_doc(key, number, item)
		end

		# set paths
		if (path.end_with?('.md'))
			path = path[0..-3] + 'html'
		else
			index = path.rindex('.')
			if (index != nil)
				ext = item[:extension]
				index2 = ext.rindex('.')
				if (index2 != nil)
					index2 += 1
					ext = ext[index2..-1]
				end
				path = path[0..index] + ext
			end
		end

		item[:site_path] = path

		if (item[:title] == nil)
			title = extract_md_title(item)
			if (title != nil)
				item[:title] = title
			end
		end
	end

	## Extracts title for the MD item
	def extract_md_title(item)
		if (item[:extension] != 'md')
			return nil
		end

		content = item.raw_content.lines.each{|l|
			if (l.start_with?('# '))
				return l[2..-1].strip()
			end
		}
		nil
	end

	## Collect documents into the map
	def add_doc(key, number, item)
		if (@config[:docs] == nil)
			@config[:docs] ||= {}
		end

		arr = @config[:docs][key]

		if (arr == nil)
			arr = []
			@config[:docs][key] = arr
		end

		arr[number.to_i] = item

		item[:docs_index] = number
		item[:docs_key] = key
	end

	## Lists all documents, optionally
	def doc_list(item, key, title)
		if (@config[:docs] == nil)
			return
		end

		if (item[:docs_key] != key)
			return
		end

		doc_list_all(item, key, title)
	end

	## Lists all documents.
	def doc_list_all(item, key, title = nil)
		arr = @config[:docs][key]

		if (arr != nil)
			str = ''
			if (title != nil)
				str = %[<h2 class='doc'>#{title}&nbsp;&nbsp;<i class="fa fa-cube"></i></h2>\n]
			end
			str << %[<ul class="doc-all">\n]

			arr[1..-1].each{|it|
				next if it == nil

				str << %[<li class="doc-item]
				if (it == item)
					str += " doc-this\"><i class=\"fa fa-caret-right\"></i>&nbsp;"
				else
					str << %["><a href="#{it[:site_path]}">]
				end

				str += it[:title]

				if (it != item)
					str << "</a>"
				end

				str << "</li>\n"
			}
			str << "</ul>\n"
		end
	end

	# Creates navigation links just for the documents
	def doc_nav(item)
		key = @item[:docs_key]
		if (key == nil)
			return nil
		end

		str = "<div class='nav'>"
		index = @item[:docs_index].to_i
		arr = @config[:docs][key]

		if (index > 1)
			# loop to find previous
			indexPrev = index - 1
			while (arr[indexPrev] == nil && indexPrev > 1)
				indexPrev = indexPrev - 1
			end
			prev = arr[indexPrev]

			str += "<a class='nav-prev' href='" + prev[:site_path] + "'>"
			str += "<i class='fa fa-chevron-circle-left'></i>&nbsp;Previous: " + prev[:title]
			str += "</a>"
		end

		if (index < arr.length - 1)
			# loop to find the next
			indexNext = index + 1
			while (arr[indexNext] == nil && indexNext < arr.length - 1)
				indexNext = indexNext + 1
			end
			nextt = arr[indexNext]

			str += "<a class='nav-next' href='" + nextt[:site_path] + "'>"
			str += "Next: " + nextt[:title] + "&nbsp;<i class='fa fa-chevron-circle-right'></i>"
			str += "</a>"
		end

		str + "</div>"
	end

end

include JoddDocs