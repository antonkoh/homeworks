print 'Введите дату в формате дд/мм/гггг: '
day,month,year=gets.split("/")
day=day.to_i
month=month.to_i
year=year.to_i

if (year%4==0 && year%100!=0) || (year%400==0)
	n_feb=29
else
	n_feb=28
end

n_array=[31,n_feb,31,30,31,30,31,31,30,31,30,31]

count=0
(month-1).times do |i|
	count+=n_array[i]
end
count+=day
puts "Это #{count}-й день года."
