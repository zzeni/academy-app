class Course < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :students

  validates :name, presence: true
  validates :category_id, presence: true

  def complete?
    max_participants.present? && students.count >= max_participants
  end
end
