class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user

  respond_to :html, :json

  # GET /requests
  # GET /requests.json 
  def index
    filter = {}
    @who_am_i = params[:who_am_i]
    if !@who_am_i
      @who_am_i = []
    end

    @ng_controller = "Requests"

    if signed_in?
      if current_user.employee
        @who_am_i.each do |i|
          filter[(i + "_id").to_sym] = current_user.employee.id
        end
      end
    end

    respond_to do |format|
      format.html { }
      format.json { render json: Request.order('created_at DESC').where(filter).collect { |r| r.attrs } }
    end
  end

  # GET /requests/1/edit
  def edit
    
  end

  def show
    respond_with @request.getFullInfo
  end

  # POST /requests
  # POST /requests.json
  def create
    @requests = Request.all
    @request  = Request.new(request_params)
    @request.registrar_id = current_user.employee ? current_user.employee.id : nil
    messages = params[:messages]

    if @request.save
      if messages
        request_tasks_count = {}

        messages.each { |m|
          request_message = RequestMessage.create(:request_id => @request.id,
                                                  :message_id => m[:id])
          message = Message.find(m[:id])
          message.tasks.each { |task|
            assigner_id = task.solver ? task.solver_id : @request.registrar_id
            request_task = RequestTask.create(:assigner_id => assigner_id,
                                              :auditor_id  => assigner_id,
                                              :task_id => task.id,
                                              :request_message_id => request_message.id,
                                              :creation_date => DateTime.now,
                                              :deadline_date => DateTime.now + task.deadline.days,
                                              :registrar_description => message.description,
                                              :email_to_assigner_date => DateTime.now)

            assigner = Employee.find(assigner_id)

            if request_tasks_count[assigner.id]
              request_tasks_count[assigner.id] += 1
            else
              request_tasks_count[assigner.id] = 1
            end
          }

          if m[:attributes]
            m[:attributes].each { |a|
              request_attribute = RequestAttribute.create(:request_message_id => request_message.id,
                                                          :attribute_id => a[:id],
                                                          :value => a[:value])
            }
          end
        }

        request_tasks_count.each { |key, value|
          params = {
            :tasks_count => value,
            :host => request.host_with_port,
            :request => @request
          }
          employee_to_send = Employee.find(key)
          employee_to_send.send_assign_email(params)
          employee_to_send.send_assign_sms(params)
        }
      end
      respond_with(@request.attrs, :status => :created, :location => @request)
    else
      respond_with(@request.errors, :status => :unprocessable_entity)
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
        format.json { render json: @request.attrs, status: :created }
      else
        format.html { render action: 'edit' }
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url }
      format.json { render json: @request.attrs }
    end
  end

  def signed_in_user
    redirect_to signin_url, notice: "Пожалуйста, войдите в систему" unless signed_in?
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_request
      @request = Request.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def request_params
      params.require(:request).permit(:machine_id, :description, :request_type_id, :phone, :request_task_id)
    end
end
