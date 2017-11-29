class AddPictireToStudent < ActiveRecord::Migration[5.1]
  def up
     add_attachment :students, :picture
   end

   def down
     remove_attachment :students, :picture
   end
end
