
class CargoTrain < Train

  def initialize(number, route = Route.new())
    init_train(number, :cargo,route)
  end
end