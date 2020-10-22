class CreateWorkoutOfferings < ActiveRecord::Migration[5.1]
  def change
    create_table :workout_offerings do |t|
      t.integer :course_offering_id
      t.integer :workout_id

      t.timestamps
    end
  end
end
