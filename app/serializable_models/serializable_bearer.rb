class SerializableBearer < JSONAPI::Serializable::Resource
  type 'bearers'

  attribute :name
end
