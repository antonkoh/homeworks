module CustomAttrAccessors

  def attr_accessor_with_history(*names)

    init_str = ''

    names.each do |name|

      name_str = name.to_s

      at_name_sym = "@#{name_str}".to_sym
      at_history_sym = "@#{name_str}_history".to_sym

      init_str += "@#{name_str}_history = []; " 

      define_method("#{name_str}".to_sym) do
        instance_variable_get(at_name_sym)
      end

      define_method("#{name_str}=".to_sym) do |value|
        instance_variable_set(at_name_sym, value)
        history = instance_variable_get(at_history_sym)
        history << value
      end

      define_method("#{name_str}_history".to_sym) do
        instance_variable_get(at_history_sym)
      end
    end

    define_method(:initialize) do
      eval(init_str)
    end
  end

  def add_to_allowed_types(var_sym,expected_type)
    @allowed_types = {} if @allowed_types == nil
    @allowed_types[var_sym] = expected_type
  end

  def get_allowed_type(var_sym)
    @allowed_types[var_sym]
  end



  def strong_attr_accessor(name, expected_type)

    name_sym = name.to_sym
    at_name_sym = "@#{name.to_s}".to_sym
    add_to_allowed_types(name_sym, expected_type)
    

    define_method(name_sym) do
      instance_variable_get(at_name_sym)
    end

    define_method("#{name.to_s}=".to_sym) do |value|
      allowed_type = self.class.get_allowed_type(name_sym)
      if value.is_a?(allowed_type)
        instance_variable_set(at_name_sym, value)
      else
        raise "Некорректный тип значения. Переменная допускает значения типа #{allowed_type}."
      end
    end

  end
end


class Foo
  extend CustomAttrAccessors

  attr_accessor_with_history :var1, 'var2'
  strong_attr_accessor :var3, Numeric
end


foo = Foo.new
puts "Присваиваем переменной var1 (задана как символ) значения 1 и 2."
foo.var1 = 1
foo.var1 = 2
puts "Последнее значение: #{foo.var1}"
puts "История: #{foo.var1_history}"

puts "Присваиваем переменной var2 (задана как строка через запятую от var1) значения a и b."
foo.var2 = 'a'
foo.var2 = 'b'
puts "Последнее значение: #{foo.var2}"
puts "История: #{foo.var2_history}"

puts "Присваиваем переменной var3 (допустимые значения - Numeric) значения 2 и 2.5"
foo.var3 = 2
puts foo.var3
foo.var3 = 2.5
puts foo.var3
puts "Присваиваем недопустимое строковое значение."
foo.var3 = 'abc'
puts foo.var3  


