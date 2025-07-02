# More realistic store schedules with different patterns
puts "Creating realistic store schedules..."

org = Organization.first
downtown = "Downtown Store" 
uptown = "Uptown Store"

# Clear existing shifts to start fresh
Shift.destroy_all
Timesheet.destroy_all

# Get employees and jobs
employees = User.where(role: 'worker')
jobs = Job.all.index_by(&:name)

week_start = Date.today.beginning_of_week

# Downtown Store - Busier, urban location
# Open 6am-10pm, needs more staff
puts "Creating Downtown Store shifts..."

7.times do |day|
  date = week_start + day.days
  
  # Early morning baker (5am-1pm) - every day
  Shift.create!(
    organization_id: org.id,
    job: jobs["Bakery Associate"],
    assigned_user: employees.sample,
    start_time: date + 5.hours,
    end_time: date + 13.hours,
    location: downtown,
    role: "Bakery"
  )
  
  # Morning stock team (6am-2pm) - 3 people on weekdays, 2 on weekends
  stock_count = day < 5 ? 3 : 2
  stock_count.times do
    Shift.create!(
      organization_id: org.id,
      job: jobs["Stock Associate"],
      assigned_user: employees.sample,
      start_time: date + 6.hours,
      end_time: date + 14.hours,
      location: downtown,
      role: "Stock"
    )
  end
  
  # Morning cashiers (8am-4pm) - 2 people
  2.times do
    Shift.create!(
      organization_id: org.id,
      job: jobs["Cashier"],
      assigned_user: employees.sample,
      start_time: date + 8.hours,
      end_time: date + 16.hours,
      location: downtown,
      role: "Cashier"
    )
  end
  
  # Lunch rush cashiers (11am-3pm) - 2 extra on weekdays
  if day < 5
    2.times do
      Shift.create!(
        organization_id: org.id,
        job: jobs["Cashier"],
        assigned_user: employees.sample,
        start_time: date + 11.hours,
        end_time: date + 15.hours,
        location: downtown,
        role: "Cashier"
      )
    end
  end
  
  # Afternoon/evening team (2pm-10pm)
  Shift.create!(
    organization_id: org.id,
    job: jobs["Shift Supervisor"],
    assigned_user: employees.sample,
    start_time: date + 14.hours,
    end_time: date + 22.hours,
    location: downtown,
    role: "Supervisor"
  )
  
  3.times do
    Shift.create!(
      organization_id: org.id,
      job: jobs["Cashier"],
      assigned_user: employees.sample,
      start_time: date + 14.hours,
      end_time: date + 22.hours,
      location: downtown,
      role: "Cashier"
    )
  end
  
  # Customer service desk (10am-8pm)
  Shift.create!(
    organization_id: org.id,
    job: jobs["Customer Service"],
    assigned_user: employees.sample,
    start_time: date + 10.hours,
    end_time: date + 20.hours,
    location: downtown,
    role: "Customer Service"
  )
  
  # Friday/Saturday night - extra coverage
  if day >= 4
    2.times do
      Shift.create!(
        organization_id: org.id,
        job: jobs["Cashier"],
        assigned_user: nil, # Open shifts
        start_time: date + 17.hours,
        end_time: date + 22.hours,
        location: downtown,
        role: "Cashier",
        status: "open"
      )
    end
  end
end

# Uptown Store - Suburban, quieter location  
# Open 7am-9pm, less staff needed
puts "Creating Uptown Store shifts..."

7.times do |day|
  date = week_start + day.days
  
  # No bakery at this location
  
  # Morning stock (7am-3pm) - 1 person
  Shift.create!(
    organization_id: org.id,
    job: jobs["Stock Associate"],
    assigned_user: employees.sample,
    start_time: date + 7.hours,
    end_time: date + 15.hours,
    location: uptown,
    role: "Stock"
  )
  
  # Morning cashier (9am-5pm) - 1 person
  Shift.create!(
    organization_id: org.id,
    job: jobs["Cashier"],
    assigned_user: employees.sample,
    start_time: date + 9.hours,
    end_time: date + 17.hours,
    location: uptown,
    role: "Cashier"
  )
  
  # Afternoon supervisor (1pm-9pm)
  Shift.create!(
    organization_id: org.id,
    job: jobs["Shift Supervisor"],
    assigned_user: employees.sample,
    start_time: date + 13.hours,
    end_time: date + 21.hours,
    location: uptown,
    role: "Supervisor"
  )
  
  # Afternoon cashier (1pm-9pm)
  Shift.create!(
    organization_id: org.id,
    job: jobs["Cashier"],
    assigned_user: employees.sample,
    start_time: date + 13.hours,
    end_time: date + 21.hours,
    location: uptown,
    role: "Cashier"
  )
  
  # Weekend - slightly busier
  if day >= 5
    # Extra morning cashier
    Shift.create!(
      organization_id: org.id,
      job: jobs["Cashier"],
      assigned_user: employees.sample,
      start_time: date + 10.hours,
      end_time: date + 18.hours,
      location: uptown,
      role: "Cashier"
    )
    
    # Customer service for returns
    Shift.create!(
      organization_id: org.id,
      job: jobs["Customer Service"],
      assigned_user: employees.sample,
      start_time: date + 11.hours,
      end_time: date + 19.hours,
      location: uptown,
      role: "Customer Service"
    )
  end
  
  # Some open shifts during week
  if day < 5 && day % 2 == 0
    Shift.create!(
      organization_id: org.id,
      job: jobs["Cashier"],
      assigned_user: nil,
      start_time: date + 16.hours,
      end_time: date + 21.hours,
      location: uptown,
      role: "Cashier",
      status: "open"
    )
  end
end

puts "Created realistic schedules:"
puts "- Downtown Store: #{Shift.where(location: downtown).count} shifts (busier urban location)"
puts "- Uptown Store: #{Shift.where(location: uptown).count} shifts (quieter suburban location)"
puts "- Open shifts: #{Shift.where(assigned_user_id: nil).count}"