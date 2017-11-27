class Course < ApplicationRecord
  belongs_to :category
  has_and_belongs_to_many :students

  scope :actual, -> {
    eager_load(:students)
    .where('min_participants IS NOT ?', nil)
    .group('courses.id')
    .having('count(students.id) >= min_participants') }

  validates :name, presence: true, length: { in: 3..50 }
  validates :level, numericality: { only_integer: true,
                                    greater_than_or_equal_to: 1,
                                    less_than_or_equal_to: 3}
  validates :category_id, presence: true
  validates :name, uniqueness: { scope: [:level, :category_id] }

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
