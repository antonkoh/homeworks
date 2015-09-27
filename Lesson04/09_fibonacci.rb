arr=[0,1]
loop do
	next_num=arr.last+arr[arr.length-2]
	break if next_num>100
	arr<<next_num
end
puts arr