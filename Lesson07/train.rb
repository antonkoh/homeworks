class Train

  def self.find(number)
    ObjectSpace.each_object(self).to_a.each do |train|
      return train if train.number == number
    end
    return nil
  end



  include Manufacturer
  attr_reader :speed, :cars, :number, :current_station, :type

  def initialize (number, type,route = Route.new())
    init_train(number,type,route)
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
    car.current_train.remove_car car unless car.current_train.nil? #если вагон прицепляем к поезду, то его надо отцепить от текущего
    index = @cars.size if index > @cars.size || index == -1 # цепляем в конец без пропуска вагонов (условие для -1 есть, чтобы потом присвоить верный current_number)
    if index >= 0 #отрицательные значения считаем некорректными (-1 уже переприсвоили)
      case self.type
        when :passenger
          @cars.insert(index,car) if car.class == PassengerCar
        when :cargo
          @cars.insert(index,car) if car.class == CargoCar
        else
          @cars.insert(index,car) #к другим типам поездам цепляем любые вагоны
        end
      car.current_train = self
      car.current_train.cars.each_with_index do |following_car,i| #обновляем номера у всех вагонов за новым
        following_car.current_number += 1 if i > index
      end
      car.current_number = index
    end
    @cars
  end

  def remove_car_by_index (index)
    if (index < @cars.size && index >= -1) #нельзя удалить вагоны за пределами массива (за исключением -1 как шортката к последнему)
      car = @cars[index]
      train = car.current_train
      car.current_number = nil
      car.current_train = nil
      @cars.delete_at(index)
       train.cars.each_with_index do |following_car,i| #обновляем номера у всех вагонов за новым
        following_car.current_number -= 1 if i >= index
      end

    end
    @cars
  end

  def remove_car (car)
    remove_car_by_index(car.current_number) if @cars.include? car && @cars[car.current_number] == car
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


protected

  def assign_route(route = Route.new())
    @current_station.send_train self if !@current_station.nil?
    @route = route
    @station_index_on_route = 0 # при смене маршрута поезд стоит на начальной станции
    @current_station = @route.stations_array[@station_index_on_route]
    @current_station.receive_train self if !current_station.nil?
    @route
  end

  def init_train(number,type,route)
    @number = number
    @type = type
    @cars = []
    @speed = 0
    assign_route(route)
  end

end
  

