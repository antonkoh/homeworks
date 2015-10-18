class TrainCar
  include Manufacturer

  attr_accessor :current_train, :current_number #вагон знает о том, куда он прицеплен, и под каким номером (начиная с 0)
  attr_reader :occupied

  def initialize(max_capacity)
    @max_capacity = max_capacity
    @occupied = 0
    @current_train = nil
    @current_number = nil
    validate_all!
  end

  def valid?
    validate_all!
    true
  rescue
    false
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
    raise "Недопустимый формат кол-ва пассажиров/груза." if !delta.class.ancestors.include? Numeric
    case self.type
    when :passenger
      raise "Кол-во пассажиров должно быть целым числом." if (delta - delta.floor) != 0
      delta = delta.to_i
    end
    raise "Кол-во пассажиров/груза должно быть положительным числом." if delta <= 0
    return delta
  end

  def available
    @max_capacity - @occupied
  end

  protected

  def validate_all!
    raise "Недопустимая вместимость вагона." if @max_capacity == nil || !@max_capacity.class.ancestors.include?(Numeric)
    raise "Недопустимое кол-во занятого места." if @occupied == nil || !@occupied.class.ancestors.include?(Numeric)
    case self.type
    when :passenger
      raise "Вместимость пассажирского вагона должна быть целым числом." if @max_capacity - @max_capacity.floor != 0
      raise "Кол-во пассажиров в вагоне должно быть целым числом." if @occupied - @occupied.floor != 0
      @max_capacity = @max_capacity.to_i
      @occupied = @occupied.to_i
    end
   
    raise "Вместимость вагона не может быть отрицательной." if @max_capacity < 0
    raise "Загруженность вагона не может быть отрицательной" if @occupied < 0
    raise "В вагоне занято мест(а) больше, чем доступно." if @max_capacity < @occupied

    raise "Недопустимый родительский поезд." if @current_train != nil && !@current_train.class.ancestors.include?(Train) #nil допустим для вагонов вне поезда
    raise "Недопустимый номер вагона в поезде." if @current_number != nil && !@current_number.class.ancestors.include?(Integer) #nil допустим
    raise "Номер вагона в поезде не может быть отрицательным." if @current_number != nil && @current_number < 0
    raise "Вагон в поезде, но номер неизвестен вагону." if @current_train != nil && @current_number == nil
    raise "Вагон имеет номер, но не прицеплен к поезду." if @current_number != nil && @current_train == nil
    raise "Рассогласованность номера вагона с информацией в поезде." if @current_number != nil && @current_train != nil && @current_train.cars[car.current_number] != car
    validate_manufacturer
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

