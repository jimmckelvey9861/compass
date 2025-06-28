class DashboardController < ApplicationController
  # Using application layout for consistent styling
  # layout 'dashboard'
  
  def index
    @organization = Organization.first
    @total_employees = User.where(organization_id: @organization&.id).count
    @active_shifts_today = Shift.where(organization_id: @organization&.id, start_time: Date.today.beginning_of_day..Date.today.end_of_day).count
    @employees_working_now = Timesheet.joins(:user).where(users: {organization_id: @organization&.id}, clock_in_time: Date.today.beginning_of_day..Time.current).where(clock_out_time: nil).count
    @open_shifts_this_week = Shift.where(organization_id: @organization&.id, assigned_user_id: nil, start_time: Date.today..Date.today.end_of_week).count
  end
end