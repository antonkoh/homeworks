module Manufacturer
  attr_accessor :manufacturer

  private
  def validate_manufacturer
    raise "Недопустимый производитель" if @manufacturer != nil && !@manufacturer.class.ancestors.include?(String)     # nil допустим (производитель неопределен)
    raise "Название производителя не может быть пустым (если производитель неопределен, устанавливется nil)" if @manufacturer != nil && @manufacturer.size == 0
  end
end