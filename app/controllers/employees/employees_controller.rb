module Employees
  class EmployeesController < ApplicationController
    def dashboard
      # Temporary user assignment until auth is implemented
      @current_user = User.where(role: 'worker').first
      
      # Get current shift for today
      @current_shift = Shift.where(
        assigned_user_id: @current_user.id,
        start_time: Date.today.beginning_of_day..Date.today.end_of_day
      ).first
      
      # Get active timesheet (if clocked in)
      @current_timesheet = Timesheet.where(
        user_id: @current_user.id,
        clock_out_time: nil
      ).last
      
      # Get upcoming shifts for the next 7 days
      @upcoming_shifts = Shift.where(
        assigned_user_id: @current_user.id,
        start_time: Date.today..7.days.from_now
      ).order(:start_time).limit(5)

      # Calculate total hours worked this week
      @week_hours = Timesheet.where(
        user_id: @current_user.id,
        clock_in_time: Date.today.beginning_of_week..Date.today.end_of_week
      ).sum(:hours_worked).round(2)
    end

    def clock_in
      # Find current user (temporary until auth)
      @current_user = User.where(role: 'worker').first
      
      # Find today's shift
      @shift = Shift.where(
        assigned_user_id: @current_user.id,
        start_time: Date.today.beginning_of_day..Date.today.end_of_day
      ).first
      
      # Create timesheet
      timesheet = Timesheet.create!(
        user_id: @current_user.id,
        shift_id: @shift&.id,
        clock_in_time: Time.current
      )
      
      redirect_to employees_dashboard_path, notice: 'Successfully clocked in!'
    end

    def clock_out
      # Find current user (temporary until auth)
      @current_user = User.where(role: 'worker').first
      
      # Find open timesheet
      timesheet = Timesheet.where(
        user_id: @current_user.id,
        clock_out_time: nil
      ).last
      
      if timesheet
        # Calculate hours worked
        clock_out_time = Time.current
        hours_worked = ((clock_out_time - timesheet.clock_in_time) / 1.hour).round(2)
        
        # Update timesheet
        timesheet.update!(
          clock_out_time: clock_out_time,
          hours_worked: hours_worked
        )
        
        redirect_to employees_dashboard_path, notice: "Successfully clocked out! Hours worked: #{hours_worked}"
      else
        redirect_to employees_dashboard_path, alert: 'No active timesheet found!'
      end
    end
  end
end