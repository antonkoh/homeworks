class PassengerTrain < Train

  def initialize(number, route = Route.new())
    init_train(number,:passenger,route)
  end

end