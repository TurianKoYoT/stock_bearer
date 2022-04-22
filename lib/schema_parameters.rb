require 'dry/schema'

module SchemaParameters
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    attr_reader :schema_definition

    def params(&block)
      @schema_definition = block
    end

    def inherited(klass)
      super

      klass.instance_variable_set('@schema_definition', @schema_definition.dup)
    end
  end

  def schema_defined?
    self.class.schema_definition.present?
  end

  def schema
    @schema ||= build_schema
  end

  def build_schema
    Dry::Schema.Params(&self.class.schema_definition)
  end
end
