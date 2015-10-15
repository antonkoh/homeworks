class TrainCar
  include Manufacturer

  attr_accessor :current_train, :current_number #вагон знает о том, куда он прицеплен, и под каким номером (начиная с 0)
  attr_reader :occupied

  def occupy(delta)
    @occupied += delta if @occupied + delta <= @max_capacity
  end

  def free (delta)
    @occupied -= delta if @occupied >= delta
  end

  def available
    @max_capacity - @occupied
  end

  protected

  def init_car
    @current_train = nil 
  end

  def get_common_description
    if @current_train.nil?
      str = 'Не прицеплен к поезду. '
    else
      str = "Номер #{@current_number + 1} в составе поезда \"#{@current_train.number}\"." 
    end
    str

  end

end

