class EmployeesController < ApplicationController
  before_action :set_employee , only: [:edit, :destroy, :update]
  before_action :signed_in_user

  respond_to :html, :json

  def index
  	@employees = Employee.all
    @ng_controller = "Employees"

    respond_with @employees
  end

  def create
    @employee = Employee.new(employee_params)

    if @employee.save
      respond_with(@employee, :status => :created, :location => @employee)
    else
      respond_with(@employee.errors, :status => :unprocessable_entity)
    end
  end

  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { render json: @employee, status: :created }
      else
        format.html { render action: 'edit' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url }
      format.json { render json: @employee }
    end
  end

  def signed_in_user
    redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
  end

  private

  	def set_employee
  	  @employee = Employee.find(params[:id])
  	end

  	def employee_params
  	  params.require(:employee).permit(:name)
  	end

end
