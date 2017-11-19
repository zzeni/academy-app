class CreateStudents < ActiveRecord::Migration[5.1]
  def change
    create_table :students do |t|
      t.string :first_name, limit: 30, null: false
      t.string :last_name, limit: 30, null: false

      t.timestamps
    end
  end
end
