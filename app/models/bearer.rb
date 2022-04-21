class Bearer < ApplicationRecord
  has_many :stocks, dependent: :destroy

  validates :name, presence: true
end
