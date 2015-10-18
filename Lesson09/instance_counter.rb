module InstanceCounter


  def self.included(base)
    base.extend ForClass
    base.send :include, ForInstance
  end

  module ForClass
    class << self
      attr_writer :count
    end

    @count = 0

    def instances
      @count
    end
  end

  module ForInstance
    private
    def register_instance
      self.class.count += 1
    end
  end
end