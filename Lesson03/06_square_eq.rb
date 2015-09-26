print "Введите коэффициенты a, b, c квадратного уравнения a*x^2 + b*x + c = 0 через пробел: "
a,b,c=gets.chomp.split
a=a.to_f
b=b.to_f
c=c.to_f

d=b**2-4*a*c

if d<0
	puts "Действительных корней нет. Дискриминант #{d} - отрицательный."
else
	x1=(-b+Math.sqrt(d))/2/a
	x2=(-b-Math.sqrt(d))/2/a
    puts "Дискриминант #{d}. Корни: #{x1}, #{x2}."
end