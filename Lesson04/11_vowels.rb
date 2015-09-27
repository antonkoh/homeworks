vowels=['a','e','i','o','u','y']
hash={}
i=0
('a'..'z').each do |letter| 
	i+=1
	hash[letter]=i if vowels.include? letter
end
puts hash