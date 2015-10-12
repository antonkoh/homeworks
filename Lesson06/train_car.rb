class TrainCar

  attr_accessor :current_train, :current_number #вагон знает о том, куда он прицеплен, и под каким номером (начиная с 0)

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


class PassengerCar < TrainCar
  attr_reader :seats_occupied

  def initialize (max_number_of_seats)
    @max_number_of_seats = max_number_of_seats.to_i
    @seats_occupied = 0
  end

  def occupy_seat
    @seats_occupied += 1 if @seats_occupied < @max_number_of_seats
  end

  def free_seat
    @seats_occupied -= 1 if @seats_occupied > 0
  end

  def seats_available
    @max_number_of_seats - @seats_occupied
  end

  def get_description
    
    "Пассажирский вагон. #{get_common_description} Всего мест: #{@max_number_of_seats}, свободных: #{seats_available}."
  end

end


class CargoCar < TrainCar
  attr_reader :capacity_occupied

  def initialize (max_capacity)
    @max_capacity = max_capacity.to_f
    @capacity_occupied = 0
  end

  def load_cargo (cargo_capacity)
    @capacity_occupied += cargo_capacity if @capacity_occupied + cargo_capacity <= @max_capacity
  end

  def unload_cargo (cargo_capacity)
    @capacity_occupied -= cargo_capacity if @capacity_occupied >= cargo_capacity
  end

  def capacity_available
    @max_capacity - @capacity_occupied
  end

  def get_description
    "Грузовой вагон. #{get_common_description}Всего объём: #{@max_capacity}, свободно: #{capacity_available}."
  end





end