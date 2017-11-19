class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :name, limit: 50, null: false
      t.integer :level, default: 0
      t.integer :category_id, null: false
      t.integer :max_participants

      t.timestamps
    end

    add_foreign_key :courses, :categories
  end
end
