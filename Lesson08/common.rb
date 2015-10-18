module CommonOutput

  def print_known(name, array)
    if array.size > 0
      puts "Известные #{name}:"
      array.each_with_index {|item, index| puts "#{index+1} - #{item.get_description}"}
    else
      puts "Известные #{name} отсутствуют."
    end
  end

end