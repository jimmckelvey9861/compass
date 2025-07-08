# Compass - AI Session Context

## Project Overview
- App: Rails 7 staff scheduling system called "Compass"
- Purpose: Workforce management for organizations
- Database: PostgreSQL
- Authentication: Rack-based (handled at higher level)

## Core Models
- Organization (central entity, owns all other resources)
- User (employees/managers with roles: worker/manager)
- Job (position types with pay rates, skills, colors)
- Shift (work periods, can be assigned to users/jobs)
- ScheduleTemplate (reusable scheduling patterns)
- Timesheet (time tracking with clock in/out)

## Current Working Features
- Organization-scoped multi-tenancy
- User roles (manager/worker)
- Job management with color coding
- Schedule template CRUD operations
- Basic shift scheduling views
- Managers dashboard

## Developer Context
- CS degree 1987, new to modern Rails
- Need explanations of Rails conventions
- Building production app

## Current Priority
Rebuilding interactive drag-and-drop scheduling interface

## Last Known Working State
- Rails server runs on localhost:3000
- All basic CRUD operations working
- Ready to add advanced scheduling features
