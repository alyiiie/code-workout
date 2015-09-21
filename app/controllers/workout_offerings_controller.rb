class WorkoutOfferingsController < ApplicationController
  load_and_authorize_resource

  #~ Action methods ...........................................................

  # -------------------------------------------------------------
  def show
    if @workout_offering
      @workout = @workout_offering.workout
      @exs = @workout.exercises
    end
    render 'workouts/show'
  end


  # -------------------------------------------------------------
  def practice
    if @workout_offering
      ex1 = nil
      if params[:exercise_id]
        ex1 = Exercise.find_by(id: params[:exercise_id])
        # FIXME: need to check that ex1 is actually in this workout
      end
      session[:current_workout] = @workout_offering.workout.id
      session[:workout_feedback] = Hash.new
      session[:workout_feedback]['workout'] =
        "You have attempted Workout #{@workout_offering.workout.name}"
      if current_user
        @workout_score = @workout_offering.score_for(current_user)
        if @workout_score.nil?
          @workout_score = WorkoutScore.new(
            score: 0,
            exercises_completed: 0,
            exercises_remaining: @workout_offering.workout.exercises.length,
            user: current_user,
            workout_offering: @workout_offering,
            workout: @workout_offering.workout)
          @workout_score.save!
        end
        current_user.current_workout_score = @workout_score
        current_user.save!
      end
      if ex1.nil?
        ex1 = @workout_offering.workout.next_exercise(
          nil, current_user, @workout_score)
      end
      redirect_to organization_workout_offering_exercise_path(
        id: ex1.id,
        organization_id:
          @workout_offering.course_offering.course.organization.slug,
        course_id: @workout_offering.course_offering.course.slug,
        term_id: @workout_offering.course_offering.term.slug,
        workout_offering_id: @workout_offering.id)
    else
      redirect_to root_path, notice: 'Workout offering not found' and return
    end
  end

end
