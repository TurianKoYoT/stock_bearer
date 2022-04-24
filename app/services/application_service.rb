require 'schema_parameters'
require 'errors_set'

class ApplicationService
  include ::SchemaParameters

  def self.call(params = {})
    new(params).send(:call)
  end

  def process; end

  def success?
    errors.blank?
  end

  def failed?
    !success?
  end

  def errors
    @errors ||= ErrorsSet.new
  end

  def call
    process if success?

    self
  end

  def initialize(params)
    initialize_by_schema(params)
  end

  def initialize_by_schema(params)
    result = schema.call(params)

    errors.merge!(result.errors.to_h) if result.failure?

    initialize_instance_variables(result)
  end

  def initialize_instance_variables(params)
    schema.rules.each_key do |attr|
      self.class.send(:attr_reader, attr)

      instance_variable_set("@#{attr}", params[attr])
    end
  end
end
