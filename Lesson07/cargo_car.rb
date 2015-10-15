class CargoCar < TrainCar
  

  def initialize (max_capacity)
    @max_capacity = max_capacity.to_f
    @occupied = 0
  end

  def get_description
    "Грузовой вагон. #{get_common_description} Всего объём: #{@max_capacity}, свободно: #{available}."
  end


end