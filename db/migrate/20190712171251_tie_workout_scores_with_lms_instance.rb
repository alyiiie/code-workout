class TieWorkoutScoresWithLmsInstance < ActiveRecord::Migration[5.1]
  def change
    add_reference :lti_workouts, :lms_instance, index: true, foreign_key: true
    add_reference :workout_scores, :lti_workout, index: true, foreign_key: true
  end
end
