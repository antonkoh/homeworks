class PassengerCar < TrainCar
  attr_reader :seats_occupied

  def type
    :passenger
  end


  def get_description    
    "Пассажирский вагон. #{get_common_description} Всего мест: #{@max_capacity}, свободных: #{available}."
  end

end