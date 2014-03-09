class MachinesController < ApplicationController
  before_action :set_machine, only: [:show]

  # GET /machines
  # GET /machines.json 
  def index
    @machines = Machine.all
  end

  # GET /machines/1
  # GET /machines/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine
      @machine = Machine.find(params[:id])
    end
end
