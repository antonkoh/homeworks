
require_relative 'train.rb'
require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train_car.rb'

private

@stations = []
@trains = []
@routes = []


def wait_for_enter
  puts "--------- Для продолжения нажмите Enter. ---------"
  gets
end

def else_go_back
  'Иначе - Вернуться назад'
end

def go_back
  puts "--- Возврат ---"
  puts
end

def else_cancel
  'Иначе - Отмена'
end

def cancel
  puts " --- Отмена ---"
  puts
end

def header(name)
  puts
  puts "=== #{name} ==="
end




def print_known(name, array)
  if array.size > 0
    puts "Известные #{name}:"
    array.each_with_index {|item, index| puts "#{index+1} - #{item.get_description}"}
  else
    puts "Известные #{name} отсутствуют."
  end
end

def get_action (question, options)
  puts question
  options.each {|string| puts string}
  action = gets.strip
  action
end



def create_dialog
  loop do
    header "Создать"
    option2_str = @stations.size == 0 ? ' (недоступно; нет известных станций)' : ''

    action = get_action('Что вы хотите создать?', ['1 - Станцию', "2 - Маршрут#{option2_str}", '3 - Поезд', else_go_back])

    case 
    when action =="1"
      create_station
    when action == "2" && @stations.size > 0
      create_route
    when action == "3"
      create_train
    else
      go_back
      break
    end
  end
end




def edit_dialog
  loop do
    header "Изменить"
    option1_str = @trains.size > 0 ? '' : " (недоступно; нет известных поездов)"
    if @trains.size > 0 && @stations.size > 0
      option2_str = ''
    elsif @trains.size > 0 && @stations.size == 0
      option2_str = " (недоступно; нет известных станций)"
    elsif @trains.size == 0 && @stations.size > 0
      option2_str = " (недоступно; нет известных поездов)"
    else
      option2_str = " (неоступно; нет известных поездов и станций)"
    end
    action = get_action("Что вы хотите изменить?", ["1 - Вагоны в поезде#{option1_str}", "2 - Поезда на станции#{option2_str}", "3 - Загрузку вагонов#{option1_str}", else_go_back])

    

    case 
    when action == "1" && @trains.size > 0
      edit_cars_on_train
    when action == "2" && @trains.size > 0 && @stations.size > 0
      edit_trains_on_station
    when action == "3" && @trains.size > 0
      edit_car_capacity
    else
      go_back
      break
    end
  end
end




def view_dialog
  loop do
    header "Просмотреть"
    action = get_action("Что вы хотите просмотреть?", ["1 - Список станций", "2 - Поезда на станции", else_go_back])
    case action
    when "1"
      puts
      print_known("станции", @stations)
      wait_for_enter
    when "2"
      view_trains_on_station
    else
      break
    end
  end
end


def create_station
  loop do
    header "Создать -> станцию"
    print "Введите название станции (оставьте пустым для возврата): "
    name = gets.strip
    if name == ''
      go_back
      break
    else
      station = Station.new(name)
      @stations << station
      puts
      puts "Станция \"#{name}\" создана."
      print_known("станции", @stations)
      puts
    end
  end
end


def create_route
  loop do
    header "Создать -> маршрут"
    print_known("станции",@stations)
    print "Перечислите номера станций через запятую (или 0 для возврата): "
    array = gets.split(',').map {|item| item.strip.to_i}
    break_input = false
    array.each {|item| break_input = true if item < 1 || item > @stations.size}
    if break_input == true
      go_back
      break
    else
      stations_array = array.map {|i| @stations[i-1]}
      route = Route.new(stations_array)
      @routes << route
      puts
      puts "Маршрут добавлен: #{route.get_description}"
      print_known("маршруты", @routes)
      puts
    end
  end
end



def create_train
  loop do
    header "Создать -> поезд"
    break_input = false
    train_type_choice = get_action('Какой поезд создать?',['1 - Пассажирский', '2 - Грузовой', '3 - Другой', else_go_back])

    case train_type_choice
    when '1'
      train_type = :passenger
    when '2'
      train_type = :cargo
    when '3'
      train_type = :other
    else
      go_back
      break_input = true
      break
    end

    if break_input == false
      option1_str = @routes.size == 0 ? ' (недоступно; нет известных маршрутов)' : ''
      puts
      need_route = get_action("Установить поезд на маршрут?", ["1 - Да#{option1_str}", '2 - Нет', else_cancel]).to_i
      case 
      when need_route == 1 && @routes.size > 0
        header "Выбор маршрута для поезда"
        print_known("маршруты",@routes)
        puts 'Иначе - Отмена'
        route_choice = gets.strip.to_i
        case
        when ((1..@routes.size).include? route_choice)
          route = @routes[route_choice - 1]
        else
          break_input = true
          cancel
        end
   
      when need_route == 2
        route = Route.new()
      else
       
        break_input = true
        go_back
      end
    end

 
    if break_input == false
      puts
      print "Введите номер поезда (оставьте пустым для отмены): "
      train_number = gets.strip
      if train_number != ''
        train = Train.new(train_number,route,train_type)
        @trains << train
        puts
        puts "Поезд \"#{train_number}\" добавлен."
        print_known("поезда",@trains)
      else
        cancel
      end
    end
  end
end



def edit_cars_on_train
  loop do
    header "Изменить -> вагоны в поезде"
    print_known("поезда", @trains)
    puts else_go_back
    print "На каком поезде изменить вагоны? "
    train_choice = gets.strip.to_i
    case
    when ((1..(@trains.size)).include? train_choice)
      train = @trains[train_choice - 1]
      train.get_description
      print_known("вагоны на данном поезде",train.cars)

      loop do
        header " Изменить -> вагоны в поезде -> \"#{train.number}\""

        option2_str = train.number_of_cars > 0 ? "" : " (недоступно; нет вагонов в поезде)"

        action = get_action('Что сделать с вагонами?',['1 - Прицепить', "2 - Отцепить#{option2_str}", else_go_back])

        case 
        when action == '1'
          break_input = false
          case train.type
          when :passenger
            puts "К этому поезду можно прицепить только пассажирские вагоны."
            car_type = :passenger
          when :cargo
            puts "К этому поезду можно прицепить только грузовые вагоны."
            car_type = :cargo
          else
            puts
            action2 = get_action("Какой вагон прицепить?", ["1 - Пассажирский","2 - Грузовой", else_cancel])
            case action2
            when '1'
              car_type = :passenger
            when '2'
              car_type = :cargo
            else
              break_input = true
              cancel
            end
          end


          if break_input == false
            case car_type
            when :passenger
              puts
              print "Сколько мест в вагоне? "
              max = gets.strip.to_i
              car = PassengerCar.new(max)
            when :cargo
              puts
              print "Какая вместительность вагона? "
              max = gets.strip.to_f
              car = CargoCar.new(max)
            end
            puts
            print "На какое место от 1 до #{train.number_of_cars + 1} прицепить вагон (0 для отмены)? "
            index = gets.strip.to_i

            if (index >= 1 && index <= train.number_of_cars + 1)
              index = 0 if index == train.number_of_cars + 1
              train.add_car(car, index - 1)
              puts
              puts "Вагон добавлен."
              print_known("вагоны в поезде \"#{train.number}\"", train.cars)
            else
              cancel
            end
          end

        when action == '2' && train.number_of_cars > 0
          puts
          print_known("вагоны в поезде \"#{train.number}\"", train.cars)
          puts else_go_back
          print "Какой вагон отцепить (0 для отмены)? "
          car_choice = gets.strip.to_i
          if (1..train.cars.size).include? car_choice
            train.remove_car_by_index(car_choice - 1)
            puts
            puts "Вагон отцеплен."
            print_known("вагоны в поезде \"#{train.number}\"", train.cars)
          else
            cancel
          end
        else
          go_back
          break
        end
      end

    else
      break
    end
  end
end



def edit_trains_on_station
  #ВАЖНО.
  #Плохое действие.
  #Правильнее двигать поезд по маршруту или перемещать по станциям.
  # Регистрация поезда на станциях должна происходить автоматически как результат действия над поездом, а не наоборот.
  # Если станция принимает/отправляет поезд сама, он сходит с маршрута (происходит рассинхронизация между тем, где он реально находится
  # и тем, на какой станции он зарегистрирован). 
  loop do
    header "Изменить -> поезда на станции"
    print_known("станции", @stations)
    puts else_go_back
    print "С какой станцией работать? "
    station_choice = gets.strip.to_i

    if (1..@stations.size).include? station_choice
      trains_on_station = []
      trains_off_station = []
      station = @stations[station_choice - 1]
      @trains.each do |train|
        if station.trains.include? train
          trains_on_station << train
        else
          trains_off_station << train
        end
      end

      option1_str = trains_off_station.size > 0 ? "" : " (недоступно; все поезда на этой станции)"
      option2_str = trains_on_station.size > 0 ? "" : " (недоступно; нет поездов на станции)" 

      puts
      puts station.get_description
      print_known("поезда на этой станции", trains_on_station)
      print_known("поезда вне этой станции", trains_off_station)

      loop do
        header "Изменить -> поезда на станции -> \"#{station.name}\""
        action = get_action('Что сделать на станции?', ["1 - Принять поезд#{option1_str}", "2 - Отправить поезд#{option2_str}", else_go_back])

        case
        when action == '1' && trains_off_station.size > 0
          puts
          print_known("поезда вне этой станции", trains_off_station)
          puts else_go_back
          print "Какой поезд принять (0 для отмены)? "
          train_choice = gets.strip.to_i
          if (1..trains_off_station.size).include? train_choice
            station.receive_train trains_off_station[train_choice - 1]
            puts
            puts "Поезд принят."
            print_known("поезда на станции \"#{station.name}\"",station.trains)
          else
            cancel
          end


        when action == '2' && trains_on_station.size > 0
          puts
          print_known("поезда на этой станции", trains_on_station)
          puts else_go_back
          print "Какой поезд отправить (0 для отмены)? "
          train_choice = gets.strip.to_i
          if (1..trains_on_station.size).include? train_choice
            station.send_train trains_on_station[train_choice - 1]
            puts
            puts "Поезд отправлен."
            print_known("поезда на станции \"#{station.name}\"",station.trains)
          else
            cancel
          end
        else
          go_back
          break
        end

      end

      
    else
      go_back
      break
    end
  end
end


def edit_car_capacity
  loop do
    header "Изменить -> загрузку вагона"
    print_known("поезда", @trains)
    puts else_go_back
    print "На каком поезде изменить загрузку? "
    train_choice = gets.strip.to_i
    break_input = false
    if (1..@trains.size).include? train_choice
      train = @trains[train_choice - 1]
      loop do
        header "Изменить -> загрузку вагона -> на поезде \"#{train.number}\""
        print_known("вагоны в поезде #{train.number}", train.cars)
        puts else_go_back
        print "В каком вагоне изменить загрузку? "
        car_choice = gets.strip.to_i
        if (1..train.cars.size).include? car_choice
          car = train.cars[car_choice-1]
          puts car.get_description

          case 
          when car.class == PassengerCar

            option1_str = car.seats_available > 0 ? "" : " (недостуно; все места заняты)"
            option2_str = car.seats_occupied > 0 ? "" : " (недоступно; все места свободны)"
            puts
           
            action = get_action("Какое действие совершить?",["1 - Занять места#{option1_str}", "2 - Освободить места#{option2_str}",else_cancel])

            case
            when action == '1' && car.seats_available > 0
              puts
              print 'Сколько мест занять? '
              num_of_seats = gets.strip.to_i
              if car.seats_available < num_of_seats
                puts
                puts "Действие не выполнено. Нет столько свободных мест."
              else
                num_of_seats.times {car.occupy_seat}
                puts
                puts "Места заняты."
                puts car.get_description

              end
            when action == '2' && car.seats_occupied > 0
              puts
              print 'Сколько мест освободить? '
              num_of_seats = gets.strip.to_i
              if car.seats_occupied < num_of_seats
                puts
                puts "Действие не выполнено. Нет столько занятых мест."
              else
                num_of_seats.times {car.free_seat}
                puts
                puts "Места освбождены."
                puts car.get_description


              end
            else
              cancel
            end

          when car.class == CargoCar 
            option1_str = car.capacity_available > 0 ? "" : " (недостуно; все место занято)"
            option2_str = car.capacity_occupied > 0 ? "" : " (недоступно; нет груза)"
            puts 
            action = get_action("Какое действие совершить?",["1 - Добавить груз#{option1_str}", "2 - Снять груз#{option2_str}",else_cancel])

            case
            when action == '1' && car.capacity_available > 0
              puts
              print 'Сколько груза добавить? '
              load = gets.strip.to_f
              if car.capacity_available < load
                puts
                puts "Действие не выполнено. Нет столько свободного места."
              elsif load > 0
                car.load_cargo(load)
                puts
                puts "Груз загружен."
                puts car.get_description
              else
                cancel
              end
               
            when action == '2' && car.capacity_occupied > 0
              puts
              print 'Сколько груза снять? '
              load = gets.strip.to_f
              if car.capacity_occupied < load
                puts
                puts "Действие не выполнено. Нет столько груза в вагоне."
              elsif load > 0
                car.unload_cargo(load)
                puts
                puts "Груз снят."
                puts car.get_description
              else
                cancel
              end
            else
              cancel
            end

          end
        else
          go_back
          break
        end
      end 
    else
      go_back
      break
    end
  end

end




def view_trains_on_station
  loop do
    puts
    print_known("станции",@stations)
    puts else_go_back
    print "Поезда на какой станции просмотреть? "
    action = gets.strip.to_i
    case
    when action == 0
      break
    when ((1..@stations.size).include? action)
      station = @stations[action.to_i - 1]
      puts
      print_known("поезда на станции \"#{station.name}\"",station.trains)
      wait_for_enter
    else
      break
    end
  end
end



loop do
  header "Основное меню"
  action = get_action("Какое действие вы хотите выполнить?", ["1 - Создать", "2 - Изменить", "3 - Просмотреть", "Иначе - Выход"])

  case action
  when "1"
    create_dialog
  when "2"
    edit_dialog
  when "3"
    view_dialog
  else
    break
  end  
end





