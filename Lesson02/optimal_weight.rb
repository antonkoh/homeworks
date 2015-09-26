puts "Как вас зовут?"
name = gets.chomp
puts "Какой ваш рост?"
height = gets.chomp.to_i
puts "#{name}, ваш идеальный вес - #{height-110}."