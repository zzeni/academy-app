class Category < ApplicationRecord
  has_many :courses

  validates :name, presence: true, uniqueness: true, length: { in: 3..30 }
end
