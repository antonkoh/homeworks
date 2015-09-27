arr=[10]
loop do
	next_num=arr.last+5
	break if next_num>100
	arr<<next_num
end
puts arr