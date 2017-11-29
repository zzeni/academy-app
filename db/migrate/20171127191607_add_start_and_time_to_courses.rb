class AddStartAndTimeToCourses < ActiveRecord::Migration[5.1]
  def up
    add_column :courses, :start_time, :datetime
    add_column :courses, :end_time, :datetime
  end

  def down
    remove_column :courses, :start_time
    remove_column :courses, :end_time
  end
end
