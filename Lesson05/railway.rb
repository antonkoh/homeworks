  
# ---------- ПОЕЗД ----------
class Train
  attr_reader :speed, :number_of_cars, :type, :number

  def initialize(number, type, number_of_cars, route = Route.new())
    @number = number

    @type = type
    
    if number_of_cars >= 1 
      @number_of_cars = number_of_cars
    else
      @number_of_cars = 1
    end

    @speed = 0

    assign_route(route)


  end


  def raise_speed
    speed_raised = false
    new_speed = @speed + 10
    if new_speed <= 110
      @speed = new_speed
      speed_raised = true
    end

    {speed_raised: speed_raised, current_speed: @speed}


  end


  def lower_speed
    speed_lowered = false
    new_speed = @speed - 10
    if new_speed >= 0
      @speed = new_speed
      speed_lowered = true 
    end

    {speed_lowered: speed_lowered, current_speed: @speed}
  end

  def add_car
    @number_of_cars += 1
  end

  def remove_car
    car_removed = false
    if @number_of_cars > 1
      @number_of_cars -= 1
      car_removed = true
    end

    {car_removed: car_removed, current_number_of_cars: @number_of_cars}
    #чтобы вызывающий метод знал и текущее кол-во вагонов и результат операции
    #(чтобы ему не приходилось сравнить "было" и "стало" для понимания, выполнилась ли команда) 
  end

  
  def move
    train_moved = false
    if @current_station < @route.stations_array.size - 1
      @route.stations_array[@current_station].send_train self if @route.stations_array.size > 0 #убираем поезд с текущей станции 
      @current_station += 1
      train_moved = true
      @route.stations_array[@current_station].receive_train self if @route.stations_array.size > 0 #добавляем поезд на новую станцию
    end

    {train_moved: train_moved, current_station: @route.stations_array[@current_station].name}
  end

  def turn #развернуть поезд на маршруте
    @route.stations_array.reverse!
    @current_station = @route.stations_array.size - @current_station - 1
  end

  def assign_route(route = Route.new())
    @route.stations_array[@current_station].send_train self if !@route.nil? && !@route.stations_array[@current_station].nil? #убираем поезд с текущей станции
    @route = route
    @current_station = 0 # при смене маршрута поезд стоит на начальной станции
    @route.stations_array[@current_station].receive_train self if !@route.stations_array[@current_station].nil? #добавляем поезд на новую станцию

  end

  

  def print_current_station
    if @route.stations_array.size == 0
      puts "Поезд не на маршруте."
    else
      puts "Поезд на станции \"#{@route.stations_array[@current_station].name}\""
    end
  end


  def print_previous_station
    if @route.stations_array.size == 0
      puts "Поезд не на маршруте."
    elsif @current_station == 0
      puts "Поезд на начальной станции \"#{@route.stations_array[@current_station].name}\""
    else
      puts "Предыдущая станция \"#{@route.stations_array[@current_station - 1].name}\""
    end
  end

  def print_next_station
    if @route.stations_array.size == 0
      puts "Поезд не на маршруте."
    elsif @current_station == @route.stations_array.size - 1
      puts "Поезд на конечной станции \"#{@route.stations_array[@current_station].name}\""
    else
      puts "Следующая станция \"#{@route.stations_array[@current_station + 1].name}\""
    end
  end

end

# ---------- ПОЕЗД (конец) ----------

# ---------- СТАНЦИЯ -----------

class Station

  attr_reader :name


  def initialize(name)
    @name = name
    @trains=[]
  end


  def receive_train(train)
    train_received = false
    if !@trains.include? train
      @trains << train
      train_received = true
    end
    {train_received: train_received, trains: @trains}
  end

  def send_train(train)
    train_sent = false
    if @trains.include? train
      @trains.delete train
      train_sent = true
    end
    {train_sent: train_sent, trains: @trains}
  end

  def print_trains
    print "Поезда на станции: "
    @trains.each do |train|
      print "#{train.number}"
      print ", " unless train == @trains.last
    end
    puts ""
  end

  
  def print_train_types
    train_types_hash = {
        passenger: {num:0, description: "пассажирских"},
        freight: {num:0, description: "грузовых"},
        other: {num:0, description: "других"}
    }

    @trains.each do |train|
      if train_types_hash.keys.include? train.type
        train_type = train.type
      else
        train_type = :other
      end
      train_types_hash[train_type][:num] += 1
    end

    puts "Поездов на станции:"
    train_types_hash.each do |train_type_key, train_type_value|
      puts "  #{train_type_value[:description]} - #{train_type_value[:num]}" unless train_type_key == :other && train_type_value[:num] == 0
    end
  end
end

# ---------- СТАНЦИЯ (конец) --------

# ---------- МАРШРУТ ----------

class Route

attr_reader :stations_array

  def initialize(first_station = nil, last_station = nil)
    @stations_array=[]
    @stations_array[0] = first_station unless first_station.nil?
    @stations_array[@stations_array.size] = last_station unless last_station.nil?
  end

  def insert_station(station,index) #-1 - добавить в конец
    station_added = false
    index = -1 if index >= @stations_array.size #нельзя добавлять с пропуском станций
    if index >= -1 #значения index < -1 считаем некорректными
      @stations_array.insert(index, station)
      station_added = true
    end

    {station_added: station_added, stations: @stations_array}
  end

  def remove_station(index) #-1 удалить последнюю
    station_removed = false
    if (index < @stations_array.size && index >= -1) #нельзя удалить станции за пределами массива (за исключением -1 как шортката к последней)
      @stations_array.delete_at(index)
      station_removed = true
    end

    {station_removed: station_removed, stations: @stations_array}
  end

  def print_route
    puts "Маршрут: "
    @stations_array.each {|station| puts"  #{station.name}"}
  end


end
# ---------- МАРШРУТ (конец) -----------
