class AddMinParticipantsToCourse < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :min_participants, :integer
  end
end
