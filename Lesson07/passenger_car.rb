class PassengerCar < TrainCar
  attr_reader :seats_occupied

  def initialize (max_number_of_seats)
    @max_capacity = max_number_of_seats.to_i
    @occupied = 0
  end


  def get_description    
    "Пассажирский вагон. #{get_common_description} Всего мест: #{@max_capacity}, свободных: #{available}."
  end

end