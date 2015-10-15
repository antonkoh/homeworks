class Route

  attr_reader :stations_array

  def initialize(stations_array = [])
    @stations_array=stations_array
  end

  def insert_station(station,index) #-1 - добавить в конец
    index = -1 if index >= @stations_array.size #нельзя добавлять с пропуском станций
    @stations_array.insert(index, station) if index >= -1 #значения index < -1 считаем некорректными
    @stations_array
  end

  def remove_station(index) #-1 удалить последнюю
    @stations_array.delete_at(index) if (index < @stations_array.size && index >= -1) #нельзя удалить станции за пределами массива (за исключением -1 как шортката к последней)
    @stations_array
  end

  def get_description
    route_string = ''
    @stations_array.each_with_index do |station,index| 
      route_string += "#{station.name}"
      route_string += ' -> ' if index < @stations_array.size - 1
    end
    route_string
  end

  


end