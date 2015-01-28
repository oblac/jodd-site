# Returns all javascript files
def all_js(files)
  js_arr = []
  for file in files
    item = @items.find{|i| i.identifier == "/js/#{file}/"}
    puts "File #{file} doesn't exist!" unless item
    js_arr << item.compiled_content
  end
  js_arr.join("\n")
end