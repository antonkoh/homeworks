class Route
  include Validation

  define_validation_descriptions({stations_array: 'набор станций',
                                  station: 'станция',
                                  station_index: 'позиция станции'})

  validation_rule :stations_array, :presence
  validation_rule :stations_array, :array_of, Station


  

  attr_reader :stations_array

  def initialize(stations_array)
    @stations_array=stations_array
    validate_all!
  end





  def insert_station(station,index) #-1 - добавить в конец
    validate_one_attr(station,nil,:station, :type, Station)
    validate_one_attr(index,nil,:station_index, :type, Integer)

    raise "Некорректное значение позиции станции. Допустимо: -1 (добавить в конец), 0..#{@stations_array.size} (ожидаемая позиция станции)." if index < -1 || index > @stations_array.size
    raise "Такая станция уже есть в маршруте." if @stations_array.include? station
    
    @stations_array.insert(index, station)
    @stations_array
  end

  def remove_station(index) #-1 удалить последнюю
    validate_one_attr(index,nil,:station_index, :type, Integer)
    
    raise "Некорректное значение позиции станции. Допустимо: -1 (последняя станция), 0..#{@cars_size - 1}." if index < -1 || index >= @stations_array.size
  
    @stations_array.delete_at(index) 
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

  private
  def validate_all!
    validate_object_by_class_rules! 
    raise "В маршруте должно быть хотя бы две станции." if @stations_array.size < 2
    @stations_array.each_with_index do |station, index|
      stations_array_temp = @stations_array.clone
      stations_array_temp.delete_at index
      raise "Станция #{station.name} присутствует в маршруте дважды." if stations_array_temp.include? station
    end
  end
end