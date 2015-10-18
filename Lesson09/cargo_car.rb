class CargoCar < TrainCar
  
  def type
    :cargo
  end


  def get_description
    "Грузовой вагон. #{get_common_description} Всего объём: #{@max_capacity}, свободно: #{available}."
  end


end