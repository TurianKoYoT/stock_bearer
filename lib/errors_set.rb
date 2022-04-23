class ErrorsSet
  def errors
    @errors ||= Hash.new { |hash, key| hash[key] = [] }
  end

  def add!(key, value)
    errors[key.to_s] = errors[key.to_s].append(value)
  end

  def merge!(new_errors)
    new_errors.each do |key, array_value|
      errors[key.to_s] += array_value
    end
  end
end
