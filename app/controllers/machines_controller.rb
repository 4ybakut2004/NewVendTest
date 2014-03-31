class MachinesController < ApplicationController
  before_action :set_machine, only: [:show]
  before_action :signed_in_user

  # GET /machines
  # GET /machines.json 
  def index
    @machines = Machine.all
  end

  def new
    @machine = Machine.new
  end

  # GET /machines/1
  # GET /machines/1.json
  def show
  end

  def create
    @machine = Machine.new(request_params)

    respond_to do |format|
      if @machine.save
        format.html { redirect_to @machine, notice: 'Machine was successfully created.' }
        format.json { render json: @machine, status: :created, location: @machine }
      else
        format.html { render action: 'new' }
        format.json { render json: @machine.errors, status: :unprocessable_entity }
      end
    end
  end

  def signed_in_user
    redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Machine.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:machine).permit(:uid, :name, :location, :machine_type)
    end
end
