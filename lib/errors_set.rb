class ErrorsSet
  def errors
    @errors ||= {}
  end

  def merge!(errors)
    self.errors.merge(errors)
  end
end
