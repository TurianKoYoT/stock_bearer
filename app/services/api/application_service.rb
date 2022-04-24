require 'errors_set/api'

module Api
  class ApplicationService < ::ApplicationService
    def error_set_class
      ErrorsSet::Api
    end
  end
end
