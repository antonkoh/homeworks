
class CargoTrain < Train

  def initialize(number, route = nil)
    init_train(number, :cargo,route)
  end
end