class EmployeesController < ApplicationController
  before_action :set_employee , only: [:show, :edit, :destroy, :update]
  before_action :signed_in_user

  def index
  	@employees = Employee.all
  	@employee = Employee.new
  end

  def edit
  end

  def create
    @employee  = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
        format.js   {}
        format.json { render json: @employee, status: :created, location: @employee }
      else
        format.html { render action: 'index' }
        format.js   {}
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @employee.update(employee_params)
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.js   {}
        format.json { render json: @employee, status: :created, location: @employee }
      else
        format.html { render action: 'edit' }
        format.js   {}
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @employee.destroy
    respond_to do |format|
      format.html { redirect_to employees_url }
      format.js   {}
      format.json { head :no_content }
    end
  end

  def employee_group_destroy
    @employee_ids = params[:for_destroy]
    Employee.where(:id => @employee_ids).destroy_all

    respond_to do |format|
      format.js {}
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
