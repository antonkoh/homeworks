print "Введите положительное целое число: "
n=gets.chomp.to_i

sum=0
(1..n).each {|i| sum+=i if i%2==0}
puts "Сумма четных: #{sum}. Среднее арифметическое: #{sum.to_f/(n/2)}."

