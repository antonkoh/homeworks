cart={}
loop do
	print "Введите название товара (или \"стоп\" для расчёта: "
	name=gets.strip
	break if name.downcase=="стоп"
	print "Введите цену за единицу товара: "
	price=gets.chomp.to_f
	print "Введите кол-во товара: "
	amount=gets.chomp.to_f
	cart[name]={price:price, amount:amount}
end

total=0
puts "CОДЕРЖИМОЕ КОРЗИНЫ:"
cart.each do |k,v|
	item_total=v[:price]*v[:amount]
	puts "#{k}. Цена: #{v[:price]}, кол-во: #{v[:amount]}, стоимость: #{item_total}"
	total+=item_total
end

puts "ИТОГО: #{total}"
