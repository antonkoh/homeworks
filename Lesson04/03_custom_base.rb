print "Введите верхнюю границу включительно: "
n=gets.chomp.to_i
print "Введите знаменатель: "
base=gets.chomp.to_i


sum=0
(1..n).each {|i| sum+=i if i%base==0}
puts "Сумма делимых на #{base}: #{sum}. Среднее арифметическое: #{sum.to_f/(n/base)}."
