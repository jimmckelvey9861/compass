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
    
    # Set view type with 'week' as default
    @view_type = params[:view_type] || 'week'
    
    # Get the start date and week range
    @week_start = (params[:week_start] ? Date.parse(params[:week_start]) : Date.current)
    # Only use beginning_of_week for week view
    @week_start = @week_start.beginning_of_week if @view_type == 'week'
    @week_end = @view_type == 'week' ? @week_start.end_of_week : @week_start

    # Get unique locations and selected location
    @locations = Shift.where(organization_id: @organization.id).distinct.pluck(:location).sort
    @selected_location = params[:location] || @locations.first
    
    # Get shifts based on view type
    date_range = @view_type == 'week' ? (@week_start..@week_end) : (@week_start.beginning_of_day..@week_start.end_of_day)
    @shifts = Shift.where(
      organization_id: @organization.id,
      start_time: date_range,
      location: @selected_location
    ).includes(:assigned_user, :job)
    
    @employees = User.where(
      organization_id: @organization.id,
      role: 'worker'
    )
    
    @available_workers = User.where(organization_id: @organization.id, role: 'worker').select(:id, :full_name)
    
    @jobs = Job.where(organization_id: @organization.id, status: 'active')
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
  def create_shift
    @organization = Organization.first
    
    # Parse the parameters
    job_id = params[:shift][:job_id]
    start_date = Date.parse(params[:shift][:start_date])
    start_time_decimal = params[:shift][:start_time].to_f
    
    # Convert decimal time to actual time
    start_hour = start_time_decimal.floor
    start_minute = ((start_time_decimal - start_hour) * 60).round
    start_datetime = start_date.beginning_of_day + start_hour.hours + start_minute.minutes
    
    # Default 4-hour shift - you can modify this
    end_datetime = start_datetime + 4.hours
    
    @shift = Shift.new(
      organization_id: @organization.id,
      job_id: job_id,
      start_time: start_datetime,
      end_time: end_datetime,
      location: params[:location] || 'Downtown Store', # Use current location
      assigned_user_id: nil # Initially unassigned
    )
    
    if @shift.save
      render json: { success: true, shift_id: @shift.id }
    else
      render json: { success: false, errors: @shift.errors.full_messages }
    end
  end  
end