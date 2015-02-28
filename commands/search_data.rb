usage       'searchdata [options]'
aliases     :sd
summary     'Generates all search data'
description 'Collections all json metas and joins into one big document'

run do |opts, args, cmd|
  puts "Collection JSON"

  json = '['
  count = 0
  Dir.glob("output/.meta/**/*.json").each{ |file|
  	if (count != 0)
  		json << ",\n"
  	end

    puts('    ' + file)
    jsonFile = File.read(file)
    json << jsonFile

    count += 1
  }

  json << ']'

  File.open('output/js/data.json', 'w') do |file|
  	file.write(json)
  end

  puts('JSON search data file written')

end