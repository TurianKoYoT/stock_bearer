class ErrorsSet
  class Api < ::ErrorsSet
    def to_json
      errors.map do |error_key, error_values|
        error_values.map do |error_value|
          {
            source: { pointer: "/data/attributes/#{error_key}" },
            title: error_value
          }
        end
      end.flatten
    end
  end
end
