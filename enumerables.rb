module Enumerable

  def my_each
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

    self.my_each { |x| temp << x if yield(x) }

    return final
  end

  def my_all?
    return self.to_enum(:my_all?) unless block_given?

    self.my_each do |x|
      if !yield(x)
        return false
      end
    end

    return true;
  end

  def my_any?
    return self.to_enum(:my_any?) unless block_given?

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

    if block_given?
      if args.length == 0
        result = args[0]
        start = 1
      else
        result = self[0]
        start = 1
      end

      self[start..self.length].my_each{ |x| result = yield(result, x) }

      return result

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
