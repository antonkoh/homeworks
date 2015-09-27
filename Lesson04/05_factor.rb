print "Введите целое положительное число: "
n=gets.chomp.to_i

fact=1
(2..n).each {|i|  fact*=i}
puts "Факториал: #{fact}." 