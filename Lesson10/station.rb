
class Station
  
  include Validation

  define_validation_descriptions({name: 'название станции',
                                  trains: 'поезда на станции',
                                  train: 'поезд'
                                  })

  validation_rule :name, :presence
  validation_rule :name, :type, String
  validation_rule :trains, :presence
  




  #---------

  attr_reader :trains, :name

  def initialize(name)
    @name = name
    @trains=[]
    validate_all!
  end




  def get_description
    "\"#{@name}\", поездов на станции: #{@trains.size}"
  end


  def receive_train(train)
    # Если использовать напрямую (минуя класс train), данные о том, где находится поезд, будут рассогласованы.
    validate_one_attr(train,nil,:train, :presence)
    validate_one_attr(train,nil, :train, :type, Train)

    raise "Поезд уже на станции." if @trains.include? train
    @trains << train
    @trains
  end

  def send_train(train)
    # Если использовать напрямую (минуя класс train), данные о том, где находится поезд, будут рассогласованы.
    validate_one_attr(train,nil,:train, :presence)
    validate_one_attr(train,nil, :train, :type, Train)
  
    raise "Поезд вне этой станции." if !@trains.include? train
    @trains.delete train
    @trains
  end

  def for_each_train_on_station
    @trains.each {|train| yield(train)}
  end

  
 

private

def validate_all!
  validate_object_by_class_rules!
    #пришлось убрать из-за дурацких send_train, receive_train, которые вызывают эту рассогласованность
    #raise "Рассогласованность между поездом и станцией в текущем положении поезда" if train.current_station != self
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
