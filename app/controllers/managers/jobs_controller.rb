module Managers
  class JobsController < ApplicationController
    before_action :set_job, only: [:edit, :update]

    def index
      @jobs = Job.where(organization_id: Organization.first.id).order(:name)
    end

    def new
      @job = Job.new
    end

    def create
      @job = Job.new(job_params)
      @job.organization_id = Organization.first.id

      if @job.save
        redirect_to managers_jobs_path, notice: 'Job position was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      # @job is set by before_action :set_job
    end

    def update
      if @job.update(job_params)
        redirect_to managers_jobs_path, notice: 'Job position was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_job
      @job = Job.where(organization_id: Organization.first.id).find(params[:id])
    end

    def job_params
      params.require(:job).permit(
        :name,
        :description,
        :required_skills,
        :min_experience_months,
        :pay_rate,
        :pay_type,
        :status,
        :color,
        required_languages: []
      )
    end
  end
end