class SerializableStock < JSONAPI::Serializable::Resource
  type 'stocks'

  attribute :name

  belongs_to :bearer
end
