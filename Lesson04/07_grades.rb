print "Введите кол-во студентов: "
n=gets.chomp.to_i

grades=[]
for i in 1..n
	grade=-1
	until (grade>=0 && grade <=100)
		print "Введите оценку #{i}-го студента от 1 до 100: "
		grade=gets.chomp.to_f
	end
	grades << grade
end

sum=0
grades.each {|i| sum+=i}
puts "Средняя оценка: #{sum/n}"

