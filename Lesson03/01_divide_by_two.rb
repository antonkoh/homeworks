print "Введите целое число: "
a=gets.chomp.to_f
if a - a.to_i != 0
	puts "Это не целое число."
#elsif .... как проверить на то, что ввели вообще не число?
else
	if a%2 == 0
		puts "Это чётное число." 
	else puts "Это нечётное число."
	end
end