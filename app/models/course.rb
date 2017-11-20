class Course < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :students

  validates :name, presence: true, length: { in: 3..50 }
  validates :category_id, presence: true

  def complete?
    max_participants.present? && students.count >= max_participants
  end

  def potential?
    min_participants.present? && students.count < min_participants
  end

  def actual?
    !potential?
  end
end
