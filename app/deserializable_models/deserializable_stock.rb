class DeserializableStock < JSONAPI::Deserializable::Resource
  attribute :name
  attribute :bearer_id
end
