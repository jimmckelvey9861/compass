# Compass Architecture

## System Design
Multi-tenant workforce management system with organization-based isolation.

## Data Model Relationships
Organization
├── Users (employees/managers)
├── Jobs (position definitions)
├── Shifts (work assignments)
├── ScheduleTemplates (reusable patterns)
└── Timesheets (time tracking)

## Authentication & Authorization
- Rack-based authentication (external system)
- Organization scoping for data isolation
- Role-based access (manager/worker)
- Controller namespaces for different user types

## Key Business Rules
- All resources belong to an organization
- Jobs have colors, pay rates, skill requirements
- Shifts can be assigned to users and jobs
- Templates define recurring schedule patterns
- Time tracking with clock in/out functionality

## Technical Stack
- Rails 7.x
- PostgreSQL
- ERB templating
- Progressive Web App capabilities
- Color-coded UI with predefined palette
