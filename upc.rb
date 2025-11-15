#encode utf-8

def upc_count()

	ori_data = read_file("game_log.tsv")
	data = ori_data
	data = data.split(/\n/)
	data.shift

	captured = []
	upc = []
	all_upv = []
	upv = []

	data.map do |x|
		i = x.split(/\t/)
		if i[3] == "captured portal"
			captured.push([i[0],i[1],i[2]])
		end
		if ['hacked friendly portal','created link','mod deployed','resonator deployed','hacked enemy portal','resonator upgraded'].index(i[3]) 
			all_upv.push([i[0],i[1],i[2]])
		end
	end

	upc = captured.uniq { |x| [x[1], x[2]] }
	upv = all_upv.uniq { |x| [x[1], x[2]] }

	printf "Unique Portals Captured: #{upc.length}"
	printf "Unique Portals Visited: #{upv.length}"


	# draw_upc = '['
	draw = '['

	google_upc_map = []
	upc_map = upc.each_slice(2000)
	upc_map.each_with_index do |data,i|
		google_upc_map[i] = "timestamp,latitude,longitude\r" 
		data.each do |x|
			draw << "{\"type\":\"marker\",\"latLng\":{\"lat\":#{x[1]},\"lng\":#{x[2]}},\"color\":\"#246bce\"},"
			google_upc_map[i] << "#{x[0]}\,#{x[1]}\,#{x[2]}\r"
		end
		write_file("upc_map_#{i}.csv",google_upc_map[i])
	end

	upv_map = upv.each_slice(50000)
	#upv_map = upv  # put all upv in one file
	google_upv_map = []
	upv_map.each_with_index do |data, i|
		google_upv_map[i] = "timestamp,latitude,longitude\r"
		data.each do |x|
			draw << "{\"type\":\"marker\",\"latLng\":{\"lat\":#{x[1]},\"lng\":#{x[2]}},\"color\":\"#1aff00\"},"
			google_upv_map[i] << "#{x[0]}\,#{x[1]}\,#{x[2]}\r"
		end
		write_file("upv_map_#{i}.csv",google_upv_map[i])
	end

	draw.chop!
	draw << ']'
	write_file("draw_out.txt",draw)

end

def read_file(file_name)
  file = File.open(file_name, "r")
  data = file.read
  file.close
  return data
end

def write_file(file_name, text)
	File.open(file_name, 'w') { |file| file.write(text) }
end

upc_count()
