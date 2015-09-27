print "Введите целое положительное число: "
n=gets.chomp.to_i

sum=0
(1..n).each {|i|  sum+=i**i}
puts "Сумма степеней: #{sum}." 