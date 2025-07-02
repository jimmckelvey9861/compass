# Demo data for Hourly Compass
puts "Creating demo data for Hourly Compass..."

# Clear existing data
puts "Clearing existing data..."
Shift.destroy_all
Timesheet.destroy_all
User.where(role: 'worker').destroy_all
Job.destroy_all

# Create organization
org = Organization.first || Organization.create!(name: "Sunset Retail Group")

# Create Jobs with realistic retail positions
puts "Creating job positions..."
jobs = {
  cashier: Job.create!(
    organization_id: org.id,
    name: "Cashier",
    description: "Handle customer transactions and provide excellent service",
    required_skills: "Cash handling, customer service, POS systems",
    required_languages: ["English"],
    min_experience_months: 0,
    pay_rate: 16.50,
    color: "#3B82F6"  # Blue
  ),
  stock: Job.create!(
    organization_id: org.id,
    name: "Stock Associate",
    description: "Receive shipments, stock shelves, maintain inventory",
    required_skills: "Lifting, inventory management, attention to detail",
    required_languages: ["English"],
    min_experience_months: 0,
    pay_rate: 17.00,
    color: "#10B981"  # Green
  ),
  supervisor: Job.create!(
    organization_id: org.id,
    name: "Shift Supervisor",
    description: "Oversee store operations and manage team during shift",
    required_skills: "Leadership, problem solving, cash management",
    required_languages: ["English", "Spanish"],
    min_experience_months: 12,
    pay_rate: 22.00,
    color: "#8B5CF6"  # Purple
  ),
  customer_service: Job.create!(
    organization_id: org.id,
    name: "Customer Service",
    description: "Handle returns, complaints, and special orders",
    required_skills: "Communication, problem resolution, patience",
    required_languages: ["English", "Spanish"],
    min_experience_months: 3,
    pay_rate: 18.00,
    color: "#F59E0B"  # Amber
  ),
  baker: Job.create!(
    organization_id: org.id,
    name: "Bakery Associate",
    description: "Prepare fresh baked goods and maintain bakery department",
    required_skills: "Food safety, baking, early morning availability",
    required_languages: ["English"],
    min_experience_months: 6,
    pay_rate: 19.00,
    color: "#EC4899"  # Pink
  )
}

# Create realistic employees
puts "Creating employees..."
employees_data = [
  # Morning crew (available 5am-2pm)
  {name: "Maria Rodriguez", email: "mrodriguez@email.com", languages: ["English", "Spanish"], preferred_shift: "morning"},
  {name: "James Chen", email: "jchen@email.com", languages: ["English", "Mandarin"], preferred_shift: "morning"},
  {name: "Sarah Johnson", email: "sjohnson@email.com", languages: ["English"], preferred_shift: "morning"},
  {name: "Ahmed Hassan", email: "ahassan@email.com", languages: ["English", "Arabic"], preferred_shift: "morning"},
  {name: "Emma Wilson", email: "ewilson@email.com", languages: ["English"], preferred_shift: "morning"},
  
  # Afternoon crew (available 12pm-9pm)
  {name: "Carlos Martinez", email: "cmartinez@email.com", languages: ["English", "Spanish"], preferred_shift: "afternoon"},
  {name: "Lisa Park", email: "lpark@email.com", languages: ["English", "Korean"], preferred_shift: "afternoon"},
  {name: "Michael Brown", email: "mbrown@email.com", languages: ["English"], preferred_shift: "afternoon"},
  {name: "Fatima Al-Rashid", email: "falrashid@email.com", languages: ["English", "Arabic"], preferred_shift: "afternoon"},
  {name: "David Thompson", email: "dthompson@email.com", languages: ["English"], preferred_shift: "afternoon"},
  
  # Evening crew (available 2pm-11pm)
  {name: "Jessica Lee", email: "jlee@email.com", languages: ["English", "Korean"], preferred_shift: "evening"},
  {name: "Roberto Silva", email: "rsilva@email.com", languages: ["English", "Portuguese"], preferred_shift: "evening"},
  {name: "Ashley Davis", email: "adavis@email.com", languages: ["English"], preferred_shift: "evening"},
  {name: "Dmitri Volkov", email: "dvolkov@email.com", languages: ["English", "Russian"], preferred_shift: "evening"},
  {name: "Nicole Martin", email: "nmartin@email.com", languages: ["English", "French"], preferred_shift: "evening"},
  
  # Flexible workers
  {name: "Tom Anderson", email: "tanderson@email.com", languages: ["English"], preferred_shift: "flexible"},
  {name: "Priya Patel", email: "ppatel@email.com", languages: ["English"], preferred_shift: "flexible"},
  {name: "Kevin O'Brien", email: "kobrien@email.com", languages: ["English"], preferred_shift: "flexible"},
  {name: "Yuki Tanaka", email: "ytanaka@email.com", languages: ["English", "Japanese"], preferred_shift: "flexible"},
  {name: "Rachel Green", email: "rgreen@email.com", languages: ["English"], preferred_shift: "flexible"}
]

employees = []
employees_data.each_with_index do |data, index|
  employee = User.create!(
    organization_id: org.id,
    email: data[:email],
    full_name: data[:name],
    phone: "555-#{1000 + index}",
    role: "worker",
    position: "Team Member",
    hourly_rate: 15.00 + (index * 0.25)  # Varying rates based on seniority
  )
  employees << employee
  
  # Assign job qualifications based on their shift preference
  case data[:preferred_shift]
  when "morning"
    # Morning workers can do stock and bakery
    JobQualification.create!(user: employee, job: jobs[:stock], certified: true, certified_date: Date.today)
    JobQualification.create!(user: employee, job: jobs[:baker], certified: true, certified_date: Date.today) if index % 2 == 0
  when "afternoon"
    # Afternoon workers can do cashier and customer service
    JobQualification.create!(user: employee, job: jobs[:cashier], certified: true, certified_date: Date.today)
    JobQualification.create!(user: employee, job: jobs[:customer_service], certified: true, certified_date: Date.today)
  when "evening"
    # Evening workers can do cashier and stock
    JobQualification.create!(user: employee, job: jobs[:cashier], certified: true, certified_date: Date.today)
    JobQualification.create!(user: employee, job: jobs[:stock], certified: true, certified_date: Date.today)
  else
    # Flexible workers can do most things
    JobQualification.create!(user: employee, job: jobs[:cashier], certified: true, certified_date: Date.today)
    JobQualification.create!(user: employee, job: jobs[:stock], certified: true, certified_date: Date.today)
    JobQualification.create!(user: employee, job: jobs[:customer_service], certified: true, certified_date: Date.today) if index % 3 == 0
  end
  
  # Some experienced workers can be supervisors
  if index % 5 == 0
    JobQualification.create!(user: employee, job: jobs[:supervisor], certified: true, certified_date: Date.today)
  end
end

puts "Created #{employees.count} employees with job qualifications"

# Create shifts for the current week
puts "Creating shifts for the week..."
week_start = Date.today.beginning_of_week
locations = ["Downtown Store", "Uptown Store"]

# For each day of the week
7.times do |day_offset|
  current_date = week_start + day_offset.days
  
  locations.each do |location|
    # Early morning shift (5am-1pm) - Stock and Bakery
    if day_offset < 6  # Not Sunday
      Shift.create!(
        organization_id: org.id,
        job: jobs[:baker],
        assigned_user: employees.sample,
        start_time: current_date + 5.hours,
        end_time: current_date + 13.hours,
        location: location,
        role: "Bakery",
        status: "scheduled"
      )
    end
    
    # Morning shifts (7am-3pm) - Stock Associates
    2.times do
      Shift.create!(
        organization_id: org.id,
        job: jobs[:stock],
        assigned_user: employees.sample,
        start_time: current_date + 7.hours,
        end_time: current_date + 15.hours,
        location: location,
        role: "Stock",
        status: "scheduled"
      )
    end
    
    # Mid-day shifts (10am-6pm) - Cashiers and Customer Service
    3.times do |i|
      job = i == 0 ? jobs[:customer_service] : jobs[:cashier]
      Shift.create!(
        organization_id: org.id,
        job: job,
        assigned_user: employees.sample,
        start_time: current_date + 10.hours,
        end_time: current_date + 18.hours,
        location: location,
        role: job.name,
        status: "scheduled"
      )
    end
    
    # Afternoon shifts (2pm-10pm) - Cashiers and Supervisors
    Shift.create!(
      organization_id: org.id,
      job: jobs[:supervisor],
      assigned_user: employees.sample,
      start_time: current_date + 14.hours,
      end_time: current_date + 22.hours,
      location: location,
      role: "Supervisor",
      status: "scheduled"
    )
    
    2.times do
      Shift.create!(
        organization_id: org.id,
        job: jobs[:cashier],
        assigned_user: employees.sample,
        start_time: current_date + 14.hours,
        end_time: current_date + 22.hours,
        location: location,
        role: "Cashier",
        status: "scheduled"
      )
    end
    
    # Create some open shifts that need coverage
    if day_offset >= 4  # Friday, Saturday, Sunday need extra help
      Shift.create!(
        organization_id: org.id,
        job: jobs[:cashier],
        assigned_user: nil,
        start_time: current_date + 16.hours,
        end_time: current_date + 21.hours,
        location: location,
        role: "Cashier",
        status: "open"
      )
    end
  end
end

# Create some timesheets for employees who have worked this week
puts "Creating timesheet records..."
completed_shifts = Shift.where("start_time < ?", Time.current).where.not(assigned_user: nil)

completed_shifts.each do |shift|
  # Most employees clock in/out on time, some are early/late
  clock_in_variance = [-5, -2, 0, 0, 0, 2, 5].sample
  clock_out_variance = [-5, -2, 0, 0, 0, 2, 5, 10].sample
  
  clock_in = shift.start_time + clock_in_variance.minutes
  clock_out = shift.end_time + clock_out_variance.minutes
  
  # Only create timesheet if the shift should have started
  if clock_in < Time.current
    timesheet = Timesheet.create!(
      user: shift.assigned_user,
      shift: shift,
      clock_in_time: clock_in,
      clock_out_time: clock_out < Time.current ? clock_out : nil,
      status: clock_out < Time.current ? "pending" : "in_progress"
    )
    
    # Calculate hours if clocked out
    if timesheet.clock_out_time
      hours = (timesheet.clock_out_time - timesheet.clock_in_time) / 1.hour
      timesheet.update(hours_worked: hours.round(2))
    end
  end
end

puts "Demo data created successfully!"
puts "- #{Job.count} job positions"
puts "- #{User.where(role: 'worker').count} employees"
puts "- #{Shift.count} shifts scheduled"
puts "- #{Shift.where(assigned_user: nil).count} open shifts need coverage"
puts "- #{Timesheet.count} timesheet records"