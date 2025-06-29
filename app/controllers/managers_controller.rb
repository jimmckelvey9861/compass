class ManagersController < ApplicationController
  def dashboard
    @organization = Organization.first
    
    # Count total staff with worker role
    @total_staff = User.where(organization_id: @organization.id, role: 'worker').count
    
    # Count currently clocked in staff
    @clocked_in_staff = Timesheet
      .joins(:user)
      .where(
        users: { organization_id: @organization.id },
        clock_in_time: Date.today.beginning_of_day..Date.today.end_of_day,
        clock_out_time: nil
      ).count
    
    # Get today's shifts
    @todays_shifts = Shift.where(
      organization_id: @organization.id,
      start_time: Date.today.beginning_of_day..Date.today.end_of_day
    )
    
    # Get open shifts for next 7 days
    @open_shifts = Shift.where(
      organization_id: @organization.id,
      assigned_user_id: nil,
      start_time: Date.today..7.days.from_now
    )
  end

  def schedule
    @organization = Organization.first
    @week_start = (params[:week_start] ? Date.parse(params[:week_start]) : Date.current).beginning_of_week
    @week_end = @week_start.end_of_week
    
    @shifts = Shift.where(
      organization_id: @organization.id,
      start_time: @week_start..@week_end
    ).includes(:assigned_user)
    
    @employees = User.where(
      organization_id: @organization.id,
      role: 'worker'
    )
    
    @available_workers = User.where(organization_id: @organization.id, role: 'worker').select(:id, :full_name)
  end

  def timesheets
    @organization = Organization.first
    @pending_timesheets = Timesheet
      .joins(:user)
      .where(
        users: { organization_id: @organization.id },
        status: 'pending'
      )
      .includes(:user, :shift)
    
    @current_period_start = Date.today.beginning_of_week
    @current_period_end = Date.today.end_of_week
  end

  def assign_shift
    @shift = Shift.find(params[:id])
    
    if @shift.update(assigned_user_id: params[:user_id])
      flash[:notice] = "Shift successfully assigned"
    else
      flash[:alert] = "Failed to assign shift: #{@shift.errors.full_messages.join(', ')}"
    end

    redirect_to managers_schedule_path(week_start: @shift.start_time.to_date)
  end
end