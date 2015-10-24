module Validation
  def self.included(base)
    base.extend ClassLevel
    base.send :include, InstanceLevel
  end

  module InstanceLevel
    def validate_one_attr(var_value, custom_var_desc,var_sym,validation_type, attrs = [])
      if !attrs.is_a?(Array)
        temp_attr = attrs
        attrs = []
        attrs[0] = temp_attr
      end

      custom_var_desc == nil ? desc = self.class.get_attr_description(var_sym) : desc = custom_var_desc
      case validation_type
      when :presence
        raise "Не задан параметр \"#{desc}\"." if (var_value == nil || (var_value.is_a?(String) && var_value.strip == ''))
      when :format
        attrs[1] == nil ? expected = '' : expected = "Ожидается: #{attrs[1]}."
        raise "Некорректный формат параметра \"#{desc}\". #{expected}" if var_value !~ attrs[0] 
      when :type
        raise "Недопустимый тип параметра \"#{desc}\". Ожидается #{attrs[0]}." if var_value != nil && !var_value.is_a?(attrs[0])
      when :array_of
        raise "Параметр \"#{desc}\" должен быть массивом." if var_value != nil && !var_value.is_a?(Array)
        var_value.each do |value,index|
          raise "Недопустимый тип элемента #{index} массива \"#{desc}\". Ожидается #{attrs[0]}/" if value == nil || !value.is_a?(attrs[0])
        end
      when :positive
        attrs[0] != 0 ? expected = 'положительным' : expected = 'неотрицательным'
        attrs[0] != 0 ? condition = (var_value > 0) : condition = (var_value >= 0)
        raise "Параметр \"#{desc}\" должен быть #{expected}." if !condition
      when :whole
        raise "Параметр \"#{desc}\" должен быть целым числом." if var_value - var_value.floor != 0
      end
    end

    def validate_object_by_class_rules!
      self.class.validation_rules.each do |var,var_rules|
        var_rules.each do |validation_type,attrs|
          validate_one_attr(instance_variable_get("@#{var.to_s}".to_sym),nil,var,validation_type,attrs)
        end
      end
    end

    def valid?
      validate_all! #validate_all - свой для каждого класса, т.к. описать все универсально не удалось
      true
    rescue
      false
    end

  end

  module ClassLevel
    def define_validation_descriptions(desc_hash)
      @description_hash ||= desc_hash
    end

    def validation_rule(var, validation_type, *attrs)
      @class_rules ||= {}
      @class_rules[var] ||= {}
      @class_rules[var][validation_type] ||= attrs
    end

    def validation_rules
      @class_rules
    end

    def get_attr_description(var)
      @description_hash[var] || var.to_s
    end
  end
end



# class Dog
#   include Validation
  
#   def initialize (breed, name, age)
#     @breed = breed
#     @name = name
#     @age = age
#     validate_object!
#   end

#   define_validation_descriptions({breed: 'порода', age: 'возраст'})
#   validation_rule :breed, :not_nil
#   validation_rule :name, :format, TRAIN_NUMBER_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i, 'три буквы или цифры, необязательный дефис, две буквы или цифры'
#   validation_rule :age, :type, Numeric

# end

# dog = Dog.new('gagaga','1дG-j','jsjsjs')