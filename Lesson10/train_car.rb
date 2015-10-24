class TrainCar
  include Manufacturer
  include Validation

  ALLOWED_TYPES = [:passenger, :cargo]

  attr_accessor :current_train, :current_number #вагон знает о том, куда он прицеплен, и под каким номером (начиная с 0)
  attr_reader :occupied, :type

  define_validation_descriptions({max_capacity: 'вместимость вагона',
                                  occupied: 'загруженность вагона',
                                  current_train: 'родительский поезд',
                                  current_number: 'номер вагона в поезде',
                                  delta: 'кол-во пассажиров (груза)',
                                  manufacturer: 'производитель вагона'
                                  })
  validation_rule :max_capacity, :presence
  validation_rule :max_capacity, :type, Numeric
  validation_rule :occupied, :presence
  validation_rule :occupied, :type, Numeric
  
  validation_rule :current_number, :type, Integer
  validation_rule :max_capacity, :positive, 0
  validation_rule :occupied, :positive, 0
  validation_rule :manufacturer, :type, String




  def initialize(type, max_capacity)
    @type = type
    @max_capacity = max_capacity
    @occupied = 0
    @current_train = nil
    @current_number = nil
    @manufacturer = nil
    validate_all!
  end

  
  def occupy(delta)
    delta = valid_delta!(delta)
    raise "В вагоне нет столько мест(а)." if @occupied + delta > @max_capacity

    @occupied += delta
  end

  def free (delta)
    delta = valid_delta!(delta)
    raise "В вагоне нет столько груза/пассажиров." if @occupied < delta
    @occupied -= delta 
  end

  def valid_delta!(delta)
    validate_one_attr(delta,:delta,:type,Numeric)
    case self.type
    when :passenger
      validate_one_attr(delta, 'кол-во пассажиров', nil, :whole)
      delta = delta.to_i
    end
    validate_one_attr(delta, nil, :delta, :positive, 1)
    return delta
  end

  def available
    @max_capacity - @occupied
  end

  def get_description
    case @type
    when :passenger
      "Пассажирский вагон. #{get_common_description} Всего мест: #{@max_capacity}, свободных: #{available}."
    when :cargo
      "Грузовой вагон. #{get_common_description} Всего объём: #{@max_capacity}, свободно: #{available}."
    end
  end

  protected

  def validate_all!
    validate_object_by_class_rules!
    raise "Неподдерживаемый тип вагона" if !ALLOWED_TYPES.include?(@type)
    
    case @type
    when :passenger
      validate_one_attr(@max_capacity,'вместимость пассажирского вагона',nil, :whole)
      validate_one_attr(@occupied,'кол-во пассажиров в вагоне',nil, :whole)
      @max_capacity = @max_capacity.to_i
      @occupied = @occupied.to_i
    end
    raise "В вагоне занято мест(а) больше, чем доступно." if @max_capacity < @occupied
    raise "Вагон в поезде, но номер неизвестен вагону." if @current_train != nil && @current_number == nil
    raise "Вагон имеет номер, но не прицеплен к поезду." if @current_number != nil && @current_train == nil
    raise "Рассогласованность номера вагона с информацией в поезде." if @current_number != nil && @current_train != nil && @current_train.cars[car.current_number] != car
  end

 

  def get_common_description
    if @current_train.nil?
      str = 'Не прицеплен к поезду. '
    else
      str = "Номер #{@current_number + 1} в составе поезда \"#{@current_train.number}\". " 
    end
    str
  end
end

