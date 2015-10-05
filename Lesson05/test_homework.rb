load './railway.rb'

# Создать несколько станций
station01 = Station.new("Серпуховская")
station02 = Station.new("Тульская")
station03 = Station.new("Пражская")
station04 = Station.new("Динамо")
station05 = Station.new("Белорусская")
station06 = Station.new("Киевская")

#Создать несколько поездов
train01 = Train.new("ПАСС001", :passenger, 10)
train02 = Train.new("ГРУЗ002", :freight, 100)
train03 = Train.new("ШТА003", :unknown, -5) #создание с неизвестным типом (разрешено) и некорректным кол-вом вагонов (установится в 1)
train04 = Train.new("ПАСС002", :passenger, 20)

#Установить поезд на станцию и убрать; каждый раз вывести текущий список поездов и типов
#Распечатаем станцию без поездов"
station01.print_trains
station01.print_train_types
#Добавим все поезда"
station01.receive_train train01
station01.receive_train train02
station01.receive_train train03
station01.receive_train train04
station01.print_trains
station01.print_train_types
#Уберём поезд неизвестного типа"
station01.send_train train03
station01.print_trains
station01.print_train_types
#Добавим дубликат поезда"
station01.receive_train train01
#Уберём отсутствующий поезд"
station01.send_train train03
station01.print_trains


#СКОРОСТЬ ПОЕЗДА
#Распечатаем скорость#
puts train01.speed
#Увеличим
train01.raise_speed
puts train01.speed
#Уменьшим
train01.lower_speed
puts train01.speed
#Уменьшим у недвигающегося поезда
train01.lower_speed
puts train01.speed
#Увеличим до недопустимых значений
20.times {train01.raise_speed}
puts train01.speed

#ВАГОНЫ
#Распечатаем вагоны
puts train03.number_of_cars
#Попробуем убрать вагонов до нуля
train03.remove_car
puts train03.number_of_cars
#Добавим 7 вагонов
7.times {train03.add_car}
puts train03.number_of_cars


#МАРШРУТ
#Составим маршрут
route=Route.new(station01, station02)
route.print_route
#Добавим станцию перед первой
route.insert_station(station03,0)
#Добавим после последней двумя способами
route.insert_station(station04,-1)
route.insert_station(station05,100)
route.print_route
#Добавим станцию с некорректным значением индекса
route.insert_station(station06,0-2)
route.print_route
#Вставим станцию нормально
route.insert_station(station06,1)
#Сложный маршрут
route.insert_station(station04,2)
route.print_route
#Удалим первую и последнюю
route.remove_station(0)
route.remove_station(-1)
route.print_route
#Удалим в середине
route.remove_station(1)
route.print_route
#Удалим за пределами массива
route.remove_station(4)
route.print_route


# ПУСТИТЬ ПО МАРШРУТУ ПОЕЗД
route=Route.new()
route.insert_station(station01,0)
route.insert_station(station02,1)
route.insert_station(station03,2)
route.insert_station(station04,3)
route.insert_station(station05,4)
route.insert_station(station03,5) #сложный маршрут
route.insert_station(station06,6)
route.print_route
#создаём поезд сразу с маршрутом
train88 = Train.new("РЖД0101", :freight, 16, route)

train88.print_previous_station
train88.print_current_station
train88.print_next_station
train88.move

train88.print_previous_station
train88.print_current_station
train88.print_next_station
10.times train88.move
train88.print_previous_station
train88.print_current_station
train88.print_next_station


train88.turn
train88.move
train88.move
train88.move
train88.print_previous_station
train88.print_current_station
train88.print_next_station

route02=Route.new(station03,station05)
train88.assign_route(route02)
train88.print_previous_station
train88.print_current_station
train88.print_next_station





