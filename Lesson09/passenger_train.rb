class PassengerTrain < Train

  def initialize(number, route = nil)
    init_train(number,:passenger,route)
  end

end