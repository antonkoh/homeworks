puts "Введите длины трёх сторон треугольника через пробел:"
a1,a2,a3=gets.chomp.split
a1=a1.to_f
a2=a2.to_f
a3=a3.to_f
if a1==a2 && a2==a3
	puts "Треугольник равносторонний."
elsif a1==a2 || a2==a3 || a1==a3
	puts "Треугольник равнобедренный."
else puts "Все стороны треугольника отличаются."
end

if a1>a2 && a1>a3
	h=a1
	k1=a2
	k1=a3
elsif a2>a1 && a2>a3
	h=a2
	k1=a1
	k2=a3
else
	h=a3
	k1=a1
	k2=a2
end
if k1**2+k2**2==h**2
	puts "Треугольник прямоугольный."
else puts "Треугольник не прямоугольный."
end
