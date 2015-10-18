class Train

  ALLOWED_TYPES = [:passenger,:cargo,:other]
  TRAIN_NUMBER_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i

  def self.find(number)
    #на мой взгляд об известных программе поездах должен знать класс Application, а не Train,
    #т.к. Train будет знать обо всех объектах типа "поезд", которые создавались,
    #но не все они могут быть значимы для программы (некоторые могут быть временными объектами и т.д.)
    Application.trains.each do |train| 
      return train if train.number == number
    end
    return nil
  end

# ----------------------------------------

  include Manufacturer
  attr_reader :speed, :cars, :number, :current_station, :type

  def initialize (number, type,route = nil)
    init_train(number,type,route)
    #валидация - в init_train, т.к. используется и при создании дочерних PassengerTrain,CargoTrain
  end

  def valid?
    validate_all!
    validate_route(@route) #исключены из validate_all, чтобы не было дублирования в assign_route
    validate_station_indicators(@route,@station_index_on_route,@current_station) #исключены из validate_all по той же причине
    true
  rescue
    false
  end



=begin

  def raise_speed
    new_speed = @speed + 10
    @speed = new_speed if new_speed <= 110
  end


  def lower_speed
    new_speed = @speed - 10
    @speed = new_speed if new_speed >= 0
  end
=end

  def add_car (car, index) # index = -1 - быстрый способ присоединить в конец
    raise "Некорректный вагон." if !car.class.ancestors.include?(TrainCar)
    raise "Недопустимая позиция вагона." if !index.class.ancestors.include? Integer
    raise "Некорректное значение позиции вагона. Допустимо: -1 (прицепить на последнее место), 0..#{@cars.size} (ожидаемая позиция вагона)." if index < -1 || index > @cars.size
    raise "К пассажирскому поезду можно цеплять только пассажирские вагоны." if self.type == :passenger && car.type != :passenger
    raise "К грузовому поезду можно цеплять только грузовые вагоны." if self.type == :cargo && car.type != :cargo

    car.current_train.remove_car car unless car.current_train.nil? #если вагон прицепляем к поезду, то его надо отцепить от текущего
    index = @cars.size if index == -1 # чтобы потом присвоить верный current_number новому вагону
     @cars.insert(index,car) #к другим типам поездам цепляем любые вагоны
    car.current_train = self
    car.current_train.cars.each_with_index do |following_car,i| #обновляем номера у всех вагонов за новым
      following_car.current_number += 1 if i > index
    end
    car.current_number = index
    @cars
  end


  def remove_car_by_index (index)
    raise "Недопустимая позиция вагона." if !index.class.ancestors.include? Integer
    raise "Некорректное значение позиции вагона. Допустимо: -1 (последний вагон), 0..#{@cars_size - 1}." if index < -1 || index >= @cars.size
    
    car = @cars[index]
    train = car.current_train
    car.current_number = nil
    car.current_train = nil
    @cars.delete_at(index)
     train.cars.each_with_index do |following_car,i| #обновляем номера у всех вагонов за новым
      following_car.current_number -= 1 if i >= index
    end
    @cars
  end


  def remove_car (car)
    raise "Нет такого вагона в поезде." if !@cars.include? car
    raise "Рассогласованность позиции вагона с информацией в поезде." if @cars[car.current_number] != car
    remove_car_by_index(car.current_number)
    @cars
  end


  def number_of_cars
    @cars.size
  end


=begin
  
  def move
    if @station_index_on_route < @route.stations_array.size - 1
      @current_station.send_train self if !@current_station.nil?
      @station_index_on_route += 1
      @current_station = @route.stations_array[@station_index_on_route]
      @current_station.receive_train self #добавляем поезд на новую станцию
    end
    @current_station
  end

  def turn #развернуть поезд на маршруте
    @route.stations_array.reverse!
    @station_index_on_route = @route.stations_array.size - @station_index_on_route - 1
    @route
  end


  def print_station_index_on_route
    if @route.stations_array.size == 0
      puts "Поезд не на маршруте."
    else
      puts "Поезд на станции \"#{@route.stations_array[@station_index_on_route].name}\""
    end
  end


  def print_previous_station
    if @route.stations_array.size == 0
      puts "Поезд не на маршруте."
    elsif @station_index_on_route == 0
      puts "Поезд на начальной станции \"#{@route.stations_array[@station_index_on_route].name}\""
    else
      puts "Предыдущая станция \"#{@route.stations_array[@station_index_on_route - 1].name}\""
    end
  end

  def print_next_station
    if @route.stations_array.size == 0
      puts "Поезд не на маршруте."
    elsif @station_index_on_route == @route.stations_array.size - 1
      puts "Поезд на конечной станции \"#{@route.stations_array[@station_index_on_route].name}\""
    else
      puts "Следующая станция \"#{@route.stations_array[@station_index_on_route + 1].name}\""
    end
  end
=end


  def get_description
    hash = {passenger: "пассажирский", cargo: "грузовой", other: "без заданного типа"}
    if hash.keys.include? @type
      train_type = @type
    else
      train_type = :other
    end
    type_description = hash[train_type]
    description = "Поезд \"#{@number}\" - #{type_description}, кол-во вагонов: #{number_of_cars}"
  end


  
  def assign_route(route = nil)
    validate_route(route)
    if route != nil
      station_index_for_check = 0
      current_station_for_check = route.stations_array[0]
    else
      station_index_for_check = nil
      current_station_for_check = nil
    end
    validate_station_indicators(route,station_index_for_check,current_station_for_check)

    @current_station.send_train self if !@current_station.nil?
    @route = route
    @station_index_on_route = station_index_for_check
    @current_station = current_station_for_check
    @current_station.receive_train self if !current_station.nil?
    @route
  end

  protected
  def init_train(number,type,route)
    @number = number
    @type = type
    @cars = []
    @speed = 0
    @manufacturer = nil
    validate_all!
    assign_route(route)
  end

  def validate_all!
    raise "Недопустимый номера поезда." if @number == nil || !number.class.ancestors.include?(String)
    raise "Номер поезда не может быть пустым." if @number.size == 0
    raise "Некорректный формат номера поезда." if @number !~ TRAIN_NUMBER_FORMAT
    raise "Поезд с таким номером уже существует." if Train.find(@number) != nil
    raise "Недопустимый тип поезда." if !ALLOWED_TYPES.include? @type
    raise "Недопустимая скорость." if @speed == nil || !@speed.class.ancestors.include?(Numeric)
    raise "Скорость не может быть отрицательной." if @speed < 0
    raise "Недопустимый набор вагонов." if !@cars.class.ancestors.include?(Array)
    @cars.each_with_index do |car, index|
      raise "Недопустимый вагон #{index}." if car == nil || !car.class.ancestors.include?(Car)
      raise "В поезде обнаружен вагон #{index} недопустимого типа." if [:passenger,:train].include? car.type && self.type != car.type
      raise "Рассогласованность номера вагона #{index} с информацией в поезде." if car.current_number != index
    end
    validate_manufacturer
  end

  
  private
  def validate_route(route)
    raise "Недопустимый маршрут." if !route == nil && !route.class.ancestors.include?(Route) #может быть nil
  end

  def validate_station_indicators(route, station_index_on_route, current_station)
    raise "Недопустимая текущая станция." if current_station != nil && !current_station.class.ancestors.include?(Station) #nil допустим (поезд вне станции)
    raise "Недопустимая позиция поезда на маршруте." if station_index_on_route != nil && !station_index_on_route.class.ancestors.include?(Integer) #nil допустим
    raise "Определен маршрут, но не определена позиция." if route != nil && station_index_on_route == nil
    raise "Определена позиция, но не определен маршрут." if route == nil && station_index_on_route != nil
    raise "Позиция поезда на маршруте за пределами маршрута." if station_index_on_route != nil && (station_index_on_route < 0 || station_index_on_route >= route.stations_array.size)
    #Рассогласованность между current_station и всем остальным не проверяем, т.к. она возникнет из-за send/receive_train станции
  end

end
  

