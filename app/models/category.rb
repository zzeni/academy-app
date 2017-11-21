class Category < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { in: 3..30 }
end
