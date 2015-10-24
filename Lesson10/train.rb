class Train

  ALLOWED_TYPES = [:passenger,:cargo,:other]

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

  include Validation

  define_validation_descriptions({number: 'номер поезда',
                                  type: 'тип поезда',
                                  cars: 'вагоны в поезде',
                                  speed: 'скорость',
                                  manufacturer: 'производитель поезда',
                                  route: 'маршрут',
                                  current_station: 'текущая станция',
                                  station_index_on_route: 'позиция поезда на маршруте',
                                  car: 'вагон',
                                  car_index: 'позиция вагона'})

  
  validation_rule :number, :presence
  validation_rule :number, :type, String
  validation_rule :number, :format, /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i, 'три буквы или цифры, необязательный дефис, две буквы или цифры'
  validation_rule :speed, :presence
  validation_rule :speed, :type, Numeric
  validation_rule :speed, :positive, 0
  validation_rule :cars, :presence
  validation_rule :cars, :array_of, TrainCar
  validation_rule :manufacturer, :type, String
  validation_rule :route, :type, Route
  validation_rule :current_station, :type, Station
  validation_rule :station_index_on_route, :type, Integer
  
    


  def initialize (number, type,route = nil)
    init_train(number,type,route)
    #валидация - в init_train, т.к. используется и при создании дочерних PassengerTrain,CargoTrain
  end


  def for_each_car_in_train
    @cars.each{|car| yield(car)}
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
    validate_one_attr(car, nil, :car, :type, TrainCar)
    validate_one_attr(index,nil,:сar_index, :type, Integer)
    
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
    validate_one_attr(index,nil, :сar_index, :type, Integer)    
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
    validate_one_attr(route, nil,:route,:type, Route)
    if route != nil
      station_index_for_check = 0
      current_station_for_check = route.stations_array[0]
    else
      station_index_for_check = nil
      current_station_for_check = nil
    end
    validate_one_attr(current_station_for_check,nil,:current_station,:type,Station)
    validate_one_attr(station_index_for_check, nil, :station_index_on_route, :type, Integer)

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
    assign_route(route)
    validate_all!
  end

  def validate_all!
    validate_object_by_class_rules!

    raise "Поезд с таким номером уже существует." if Train.find(@number) != nil
    raise "Недопустимый тип поезда." if !ALLOWED_TYPES.include? @type
    @cars.each_with_index do |car, index|
      raise "В поезде обнаружен вагон #{index} недопустимого типа." if [:passenger,:train].include? car.type && self.type != car.type
      raise "Рассогласованность номера вагона #{index} с информацией в поезде." if car.current_number != index
    end
  end

  
  private

  def validate_station_indicators(route, station_index_on_route, current_station)    
    raise "Определен маршрут, но не определена позиция." if route != nil && station_index_on_route == nil
    raise "Определена позиция, но не определен маршрут." if route == nil && station_index_on_route != nil
    raise "Позиция поезда на маршруте за пределами маршрута." if station_index_on_route != nil && (station_index_on_route < 0 || station_index_on_route >= route.stations_array.size)
    #Рассогласованность между current_station и всем остальным не проверяем, т.к. она возникнет из-за send/receive_train станции
  end

end
  

class TrainCar #не мог это сделать в самом TrainCar , т.к. он не знал о существовании Train
  validation_rule :current_train, :type, Train
end

class Station
  validation_rule :trains, :array_of, Train
end