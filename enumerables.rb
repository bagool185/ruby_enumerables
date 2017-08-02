module Enumerable

  def my_each
    # if a block isn't provided, return an Enumerable
    return self.to_enum(:my_each) unless block_given?

    for x in 0...length
      yield(self[x])
    end

    return self
  end

  def my_each_with_index
    return self.to_enum(:my_each_with_index) unless block_given?

    for x in 0...length
      yield(self[x], x)
    end

    return self
  end

  def my_select
    return self.to_enum(:my_select) unless block_given?

    final = []

    # add elements that respect the imposed criteria to the final enumerable
    self.my_each { |x| temp << x if yield(x) }

    return final
  end

  def my_all?
    return self.to_enum(:my_all?) unless block_given?

    # it's sufficient to find one value that doesn't respect the imposed
    # criteria to return false
    self.my_each do |x|
      if !yield(x)
        return false
      end
    end

    return true;
  end

  def my_any?
    return self.to_enum(:my_any?) unless block_given?

    # it's sufficient to find one value that does respect the imposed
    # criteria to return true
    self.my_each do |x|
      if yield(x)
        return true
      end
    end

    return false
  end

  def my_count(value = false)

    count = 0

    if block_given?
      self.my_each { |x| count += yield(x) ? 1 : 0 }
    else
      # if the block isn't provided and the method is called with a parameter
      # it will count all it's occurances in the enumerable
      self.my_each { |x| count += (x == value) ? 1 : 0 }
    end

    return count
  end

  def my_map (proc = nil)
    new_arr = []

    return self.to_enum(:my_map) unless block_given? || proc

    if proc
      self.my_each { |x| new_arr << proc.call(x) }
    else
      self.my_each { |x| new_arr << yield(x) }
    end

    return new_arr
  end

  def my_inject(*args)

    # if a block is provided and there are no parameteres, the result
    # is initialized with the first value of the enumerable, otherwise
    # it will take the value of the parameter
    if block_given?
      if args.length == 0
        result = self[0]
        start = 1
      else
        result = args[0]
        start = 0
      end

      self[start..self.length].my_each{ |x| result = yield(result, x) }

      return result

    # if the method has a parameter and no block means that the argument
    # is a symbol indicating the operation , otherwise, it will have 2
    # parameters: the first one initializes the result and the other one
    # is the intended operation 
    elsif args.length == 1
      operation = args[0]
      result = self[0]
    else
      result = args[0]
      operation = args[1]
    end

    case operation
    when :+
      self[1..self.length].each { |x| result += x }
    when :-
      self[1..self.length].each { |x| result -= x }
    when :*
      self[1..self.length].each { |x| result *= x }
    when :/
      self[1..self.length].each { |x| result /= x }
    end

    return result
  end

end
