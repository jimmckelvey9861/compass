class PositionsController < ApplicationController
  before_action :set_position, only: [:show, :edit, :update, :destroy]

  def index
    @positions = Position.all
  end

  def show
  end

  def new
    @position = Position.new
  end

  def edit
  end

  def create
    @position = Position.new(position_params)

    if @position.save
      redirect_to @position, notice: 'Position was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @position.update(position_params)
      redirect_to @position, notice: 'Position was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @position.destroy
    redirect_to positions_url, notice: 'Position was successfully deleted.'
  end

  private

  def set_position
    @position = Position.find(params[:id])
  end

  def position_params
    params.require(:position).permit(
      :company_name,
      :title,
      :description,
      :location,
      :availability_required,
      :legal_disclosures,
      :other_information,
      requirements: [],
      identity_fields_required: [],
      video_questions: []
    )
  end
end