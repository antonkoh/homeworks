class Application
  extend CommonOutput

  ALLOWED_FLOAT = /^\d{0,10}(\.\d{0,10})?$/


  @@stations = []
  @@trains = []
  @@routes = []
  
  class << self

  def trains
    @@trains
  end

  def stations
    @@stations
  end

  def routes
    @@routes
  end




  def main_menu
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
  end



  private



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
    puts "--- Отмена ---"
    puts
  end

  def unavailable
    puts "Недоступное действие."
  end

  def incorrect
    puts "Некорректный ввод."
  end

  def header(name)
    puts
    puts "=== #{name} ==="
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
      option2_str = @@stations.size == 0 ? ' (недоступно; нет известных станций)' : ''

      action = get_action('Что вы хотите создать?', ['1 - Станции', "2 - Маршруты#{option2_str}", '3 - Поезда', else_go_back])

      case 
      when action =="1"
        create_stations
      when action == "2"
        if @@stations.size > 0
          create_routes
        else
          unavailable
          cancel
        end
      when action == "3"
        create_trains
      else
        go_back
        break
      end
    end
  end




  def edit_dialog
    loop do
      header "Изменить"
      option1_str = @@trains.size > 0 ? '' : " (недоступно; нет известных поездов)"
      if @@trains.size > 0 && @@stations.size > 0
        option2_str = ''
      elsif @@trains.size > 0 && @@stations.size == 0
        option2_str = " (недоступно; нет известных станций)"
      elsif @@trains.size == 0 && @@stations.size > 0
        option2_str = " (недоступно; нет известных поездов)"
      else
        option2_str = " (неоступно; нет известных поездов и станций)"
      end
      action = get_action("Что вы хотите изменить?", ["1 - Вагоны в поездах#{option1_str}", "2 - Поезда на станциях#{option2_str}", "3 - Загрузку вагонов#{option1_str}", else_go_back])

      case 
      when action == "1"
        if @@trains.size > 0
          edit_cars_on_trains
        else
          unavailable
          cancel
        end
        
      when action == "2"
        if @@trains.size > 0 && @@stations.size > 0
          edit_trains_on_stations
        else
          unavailable
          cancel
        end
        
      when action == "3" 
        if @@trains.size > 0
          edit_cars_capacity
        else
          unavailable
          cancel
        end
        
      else
        go_back
        break
      end
    end
  end




  def view_dialog
    loop do
      header "Просмотреть"
      action = get_action("Что вы хотите просмотреть?", ["1 - Список станций", "2 - Поезда на станциях", else_go_back])
      case action
      when "1"
        puts
        print_known("станции", @@stations)
        wait_for_enter
      when "2"
        view_trains_on_stations
      else
        go_back
        break
      end
    end
  end


  def create_stations
    loop do
      header "Создать -> станции"
      print "Введите название станции (оставьте пустым для возврата): "
      name = gets.strip
      if name == ''
        go_back
        break
      else
        begin
          station = Station.new(name)
          @@stations << station
          puts
          puts "Станция \"#{name}\" создана."
          print_known("станции", @@stations)
          puts
        rescue RuntimeError => e
          puts "#{e.message}"
          cancel
        end
      end
    end
  end


  def create_routes
    loop do
      header "Создать -> маршруты"
      print_known("станции",@@stations)
      print "Перечислите номера станций через запятую (оставьте пустым для возврата): "
      input_string = gets.strip
      if input_string == ''
        go_back
        break
      end
      array = input_string.split(',').map {|item| item.strip.to_i}

      break_input = (array.size == 0) ? true : false
      array.each {|item| break_input = true if item < 1 || item > @@stations.size}

      if break_input == true
        incorrect
        cancel
      else
        stations_array = array.map {|i| @@stations[i-1]}
        begin
          route = Route.new(stations_array)
          @@routes << route
          puts
          puts "Маршрут добавлен: #{route.get_description}"
          print_known("маршруты", @@routes)
          puts
        rescue RuntimeError => e
          puts "#{e.message}"
          cancel
        end
      end
    end
  end



  def create_trains
    loop do
      header "Создать -> поезда"

      train_type = ask_train_type
      break if train_type == :go_back
      
      route = ask_route
      
      unless route == :cancel
        puts
        print "Введите номер поезда (оставьте пустым для отмены): "
        train_number = gets.strip
        if train_number != ''
          begin
            train = Train.new(train_number,train_type, route)
            @@trains << train
            puts
            puts "Поезд \"#{train_number}\" добавлен."
            print_known("поезда",@@trains)
          rescue RuntimeError => e
            puts "#{e.message}"
            cancel
          end
        else
          cancel
        end
      end
    end
  end

  def ask_train_type
    train_type_choice = get_action('Какой поезд создать?',['1 - Пассажирский', '2 - Грузовой', '3 - Другой', else_go_back])

    case train_type_choice
    when '1'
      return :passenger
    when '2'
      return :cargo
    when '3'
      return :other
    else
      go_back
      return :go_back
    end
  end


  

  def ask_route
    option1_str = @@routes.size == 0 ? ' (недоступно; нет известных маршрутов)' : ''
    puts
    need_route = get_action("Установить поезд на маршрут?", ["1 - Да#{option1_str}", '2 - Нет', else_cancel]).to_i

    case 
    when need_route == 1
      if @@routes.size > 0
        header "Выбор маршрута для поезда"
        print_known("маршруты",@@routes)
        puts else_cancel
        route_choice = gets.strip.to_i
        case
        when ((1..@@routes.size).include? route_choice)
          return @@routes[route_choice - 1]
        else
          cancel
          return :cancel
        end
      else
        unavailable
        cancel
        return :cancel
      end
 
    when need_route == 2
      return nil

    else
      cancel
      return :cancel
    end
  end



  def edit_cars_on_trains
    loop do
      header "Изменить -> вагоны в поездах"
      print_known("поезда", @@trains)
      puts else_go_back
      print "На каком поезде изменить вагоны? "
      train_choice = gets.strip.to_i
      case
      when ((1..(@@trains.size)).include? train_choice)
        train = @@trains[train_choice - 1]
        edit_cars_on_train(train)
      else
        go_back
        break
      end
    end
  end


  def edit_cars_on_train(train)
    puts
    puts train.get_description
    print_known("вагоны на данном поезде",train.cars)

    loop do
      header " Изменить -> вагоны в поездах -> поезд \"#{train.number}\""

      option2_str = train.number_of_cars > 0 ? "" : " (недоступно; нет вагонов в поезде)"

      action = get_action('Что сделать с вагонами?',['1 - Прицепить', "2 - Отцепить#{option2_str}", else_go_back])

      case 
      when action == '1'
        add_cars(train)
      when action == '2'
        if train.number_of_cars > 0
          remove_cars(train)
        else
          unavailable
          cancel
        end
      else
        go_back
        break
      end
    end
  end


  def remove_cars(train)
    puts
    print_known("вагоны в поезде \"#{train.number}\"", train.cars)
    puts else_cancel
    print "Какой вагон отцепить? "
    car_choice = gets.strip.to_i
    if (1..train.cars.size).include? car_choice
      begin
        train.remove_car_by_index(car_choice - 1)
        puts
        puts "Вагон отцеплен."
        print_known("вагоны в поезде \"#{train.number}\"", train.cars)
      rescue RuntimeError => e
        puts e.message
        cancel
      end
    else
      cancel
    end
  end


  def add_cars(train)
    car_type = ask_car_type_to_add(train.type)

    if [:passenger, :cargo].include? car_type
    
      puts
      car_type == :passenger ? (print "Сколько мест в вагоне? ") : (print "Какая вместительность вагона? ")
      max = gets.strip
      unless max !~ ALLOWED_FLOAT
        max = max.to_f
        begin
          car = TrainCar.new(car_type,max)
        rescue RuntimeError => e
          puts e.message
          cancel
          return
        end
      
        loop do
          puts
          print "На какое место от 1 до #{train.number_of_cars + 1} прицепить вагон (оставьте пустым для отмены)? "
          index = gets.strip
          if index == ''
            cancel
            return
          end

          index = index.to_i
          if (index >= 1 && index <= train.number_of_cars + 1)
            begin
              index = 0 if index == train.number_of_cars + 1
              train.add_car(car, index - 1)
              puts
              puts "Вагон добавлен."
              print_known("вагоны в поезде \"#{train.number}\"", train.cars)
              break
            rescue RuntimeError => e
              puts e
              cancel
            end
          else
            incorrect
          end
        end
      else
        incorrect
      end
    end
  end

  def ask_car_type_to_add(train_type)
    case train_type
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
        return :passenger
      when '2'
        return :cargo
      else
        cancel
        return :cancel
      end
    end
  end




  def edit_trains_on_stations
    #ВАЖНО.
    #Плохое действие.
    #Правильнее двигать поезд по маршруту или перемещать по станциям.
    # Регистрация поезда на станциях должна происходить автоматически как результат действия над поездом, а не наоборот.
    # Если станция принимает/отправляет поезд сама, он сходит с маршрута (происходит рассинхронизация между тем, где он реально находится
    # и тем, на какой станции он зарегистрирован). 
    loop do
      header "Изменить -> поезда на станциях"
      print_known("станции", @@stations)
      puts else_go_back
      print "С какой станцией работать? "
      station_choice = gets.strip.to_i

      if (1..@@stations.size).include? station_choice
        station = @@stations[station_choice - 1]
        edit_trains_on_station(station)
      else
        go_back
        break
      end
    end
  end


  def edit_trains_on_station(station)
    loop do
      trains_on_station = []
      trains_off_station = []
      @@trains.each do |train|
        if station.trains.include? train
          trains_on_station << train
        else
          trains_off_station << train
        end
      end
      
      
      option1_str = trains_off_station.size > 0 ? "" : " (недоступно; все поезда на этой станции)"
      option2_str = trains_on_station.size > 0 ? "" : " (недоступно; нет поездов на станции)" 

      header "Изменить -> поезда на станциях -> станция \"#{station.name}\""
      puts station.get_description
      print_known("поезда на этой станции", trains_on_station)
      print_known("поезда вне этой станции", trains_off_station)
      puts
      action = get_action('Что сделать на станции?', ["1 - Принять поезд#{option1_str}", "2 - Отправить поезд#{option2_str}", else_go_back])

      case
      when action == '1'
        if trains_off_station.size > 0
          send_receive_trains(:receive,station,trains_off_station)
        else
          unavailable
          cancel
        end

      when action == '2'
        if trains_on_station.size > 0
          send_receive_trains(:send,station,trains_on_station)
        else
          unavailable
          cancel
        end

      else
        go_back
        break
      end
    end
  end


  def send_receive_trains(action,station, train_array)
    hash = {send: ['отправить','отправлен','на'], receive: ['принять','принят','вне']}
    return if !hash.keys.include? action

    puts
    print_known("поезда #{hash[action][2]} этой станции", train_array)
    puts else_cancel
    print "Какой поезд #{hash[action][0]}? "
    train_choice = gets.strip.to_i
    if (1..train_array.size).include? train_choice
      begin
        train = train_array[train_choice - 1]
        case action
        when :receive
          train.current_station.send_train train
          station.receive_train train
        when :send
          station.send_train train
        end

        puts
        puts "Поезд \"#{train.number}\" #{hash[action][1]}."
      rescue RuntimeError => e
        puts e.message
        cancel
      end
    else
      cancel
    end
  end


  def edit_cars_capacity
    loop do
      header "Изменить -> загрузку вагонов"
      print_known("поезда", @@trains)
      puts else_go_back
      print "На каком поезде изменить загрузку? "
      train_choice = gets.strip.to_i
      if (1..@@trains.size).include? train_choice
        train = @@trains[train_choice - 1]
        edit_car_capacity_on_train(train)         
      else
        go_back
        break
      end
    end
  end


  def edit_car_capacity_on_train(train)
    loop do
      header "Изменить -> загрузку вагонов -> на поезде \"#{train.number}\""
      print_known("вагоны в поезде #{train.number}", train.cars)
      if train.cars.size > 0
        puts else_go_back
        print "В каком вагоне изменить загрузку? "
        car_choice = gets.strip.to_i
        if (1..train.cars.size).include? car_choice
          car = train.cars[car_choice-1]
          edit_car_capacity(car)
        else
          go_back
          break
        end
      else
        wait_for_enter
        go_back
        break
      end
    end
  end



  def edit_car_capacity(car)
    puts
    puts car.get_description      
    case 
    when car.type == :passenger
      all_occupied_desc = 'нет свободных мест'
      all_free_desc = 'нет пассажиров на местах'
      occupy_desc = 'Занять места'
      free_desc = 'Освободить места'
      how_much_occupy_desc = 'Сколько мест занять?'
      how_much_free_desc = 'Сколько мест освободить?'
      occupy_done = 'Места заняты.'
      free_done = 'Места освобождены.'
    when car.type == :cargo      
      all_occupied_desc = 'нет свободного места'
      all_free_desc = 'нет груза'
      occupy_desc = 'Добавить груз'
      free_desc = 'Снять груз'
      how_much_occupy_desc = 'Сколько груза добавить?'
      how_much_free_desc = 'Сколько груза снять?'
      occupy_done = 'Груз добавлен.'
      free_done = 'Груз снят.'
    end

    option1_str = car.available > 0 ? "" : " (недостуно; #{all_occupied_desc})"
    option2_str = car.occupied > 0 ? "" : " (недоступно; #{all_free_desc})"
    puts
   
    action = get_action("Какое действие совершить?",["1 - #{occupy_desc}#{option1_str}", "2 - #{free_desc}#{option2_str}",else_cancel])

    case action
    when '1'
      question = how_much_occupy_desc
      done = occupy_done
      compare = car.available
    when '2'
      question = how_much_free_desc
      done = free_done
      compare = car.occupied
    end

    if (action == '1' && car.available > 0) || (action == '2' && car.occupied > 0) 
      puts
      print "#{question} "
    load !~ ALLOWED_FLOAT
      load = load.to_f
      begin
        action == '1' ? car.occupy(load) : car.free(load)
        puts
        puts "#{done}"
        puts car.get_description
      rescue RuntimeError => e
        puts e.message
        cancel
      end
      elsif (action == '1' && car.available <= 0) || (action == '2' && car.occupied <= 0)
      unavailable
      cancel
    else
      cancel
    end
  end




  def view_trains_on_stations
    loop do
      puts
      print_known("станции",@@stations)
      if @@stations.size > 0
        puts else_go_back
        print "Поезда на какой станции просмотреть? "
        action = gets.strip.to_i
        case
        when action == 0
          break
        when ((1..@@stations.size).include? action)
          station = @@stations[action - 1]
          puts
          print_known("поезда на станции \"#{station.name}\"",station.trains)
          wait_for_enter
        else
          go_back
          break
        end
      else
        wait_for_enter
        go_back
        break
      end
    end
  end
end

end