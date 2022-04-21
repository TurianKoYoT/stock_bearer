class Stock < ApplicationRecord
  acts_as_paranoid

  belongs_to :bearer

  validates :name, :bearer_id, presence: true
end
