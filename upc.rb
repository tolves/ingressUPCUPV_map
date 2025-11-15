#encode utf-8

def upc_count()

	ori_data = read_file("portal_history.tsv")
	data = ori_data
	data = data.split(/\n/)
	data.shift

	captured = []
	upc = []
	all_upv = []
	upv = []

	data.map do |x|
		i = x.split(/\t/)
		if i[0] == "Captured"
			captured.push([i[1].to_f,i[2].to_f])
		end
		all_upv.push([i[1].to_f,i[2].to_f])
	end

	upc = captured.uniq
	upv = all_upv.uniq

	draw = '['

	google_upc_map = []
	upc_map = upc.each_slice(2000)
	upc_map.each_with_index do |data,i|
		google_upc_map[i] = "latitude,longitude\r" 
		data.each do |x|
			draw << "{\"type\":\"marker\",\"latLng\":{\"lat\":#{x[0]},\"lng\":#{x[1]}},\"color\":\"#246bce\"},"
			google_upc_map[i] << "#{x[0]}\,#{x[1]}\r"
		end
		write_file("upc_map_#{i}.csv",google_upc_map[i])
	end

	upv_map = upv.each_slice(2000)
	google_upv_map = []
	upv_map.each_with_index do |data, i|
		google_upv_map[i] = "latitude,longitude\r"
		data.each do |x|
			draw << "{\"type\":\"marker\",\"latLng\":{\"lat\":#{x[0]},\"lng\":#{x[1]}},\"color\":\"#1aff00\"},"
			google_upv_map[i] << "#{x[0]}\,#{x[1]}\r"
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
