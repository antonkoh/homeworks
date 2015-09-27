print "Введите положительное целое число: "
n=gets.chomp.to_i

sum=0
for i in 1..n
	sum+=i
end
puts "Цикл for.   Сумма: #{sum}. Среднее арифметическое: #{sum.to_f/n}."

sum=0
i=1
while i<=n do
	sum+=i
	i+=1
end
puts "Цикл while. Сумма: #{sum}. Среднее арифметическое: #{sum.to_f/n}."

sum=0
i=1
until i>n do
	sum+=i
	i+=1
end
puts "Цикл until. Сумма: #{sum}. Среднее арифметическое: #{sum.to_f/n}."

sum=0
(1..n).each {|i| sum+=i}
puts "Цикл each.  Сумма: #{sum}. Среднее арифметическое: #{sum.to_f/n}."


