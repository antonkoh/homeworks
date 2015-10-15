

class Station
  extend CommonOutput
  def self.all
    print_known('станции',ObjectSpace.each_object(self).to_a)
  end 


  #---------

  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains=[]
  end



  def get_description
    "\"#{@name}\", поездов на станции: #{@trains.size}"
  end


  def receive_train(train)
    # Если использовать напрямую (минуя класс train), данные о том, где находится поезд, будут рассогласованы.
    @trains << train if !@trains.include? train
    @trains
  end

  def send_train(train)
    # Если использовать напрямую (минуя класс train), данные о том, где находится поезд, будут рассогласованы.
    @trains.delete train if @trains.include? train
    @trains
  end


=begin
  def print_trains
    print "Поезда на станции \"#{self.name}\": "
    @trains.each_with_index do |train, index|
      print "#{train.number}"
      print ", " unless index == @trains.size - 1
    end
    puts ""
  end

  
  def print_train_types
    train_types_hash = {
        passenger: {num:0, description: "пассажирских"},
        cargo: {num:0, description: "грузовых"},
        other: {num:0, description: "других"}
    }

    @trains.each do |train|
      if train_types_hash.keys.include? train.type
        train_type = train.type
      else
        train_type = :other
      end
      train_types_hash[train_type][:num] += 1
    end

    puts "Поездов на станции:"
    train_types_hash.each do |train_type_key, train_type_value|
      puts "  #{train_type_value[:description]} - #{train_type_value[:num]}" unless train_type_key == :other && train_type_value[:num] == 0
    end
  end
=end

end
