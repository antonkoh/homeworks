print "Введите номер дня недели: "
day =gets.chomp.to_i
case
	when day==1
		puts "Понедельник"
	when day==2
		puts "Вторник"
	when day==3
		puts "Среда"
	when day==4
		puts "Четверг"
	when day==5
		puts "Пятница"
	when day==6
		puts "Суббота"
	when day==7
		puts "Воскресенье"
	else
		puts "Неверный день недели"
end