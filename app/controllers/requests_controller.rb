class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user

  # GET /requests
  # GET /requests.json 
  def index
    filter = {}
    @who_am_i = params[:who_am_i]
    if !@who_am_i
      @who_am_i = []
    end

    if signed_in?
      if current_user.employee
        @who_am_i.each do |i|
          filter[(i + "_id").to_sym] = current_user.employee.id
        end
      end
    end


    @requests = Request.order('created_at DESC').where(filter)
    @request  = Request.new
    @messages = Message.all
  end

  # GET /requests/1
  # GET /requests/1.json
  def show
  end

  # GET /requests/new
  def new
    @request = Request.new
  end

  # GET /requests/1/edit
  def edit
    
  end

  # POST /requests
  # POST /requests.json
  def create
    @requests = Request.all
    @request  = Request.new(request_params)
    @request.registrar_id = current_user.employee ? current_user.employee.id : nil
    messages = params[:messages]

    respond_to do |format|
      if @request.save
        if messages
          messages.each { |message_id|
            request_message = RequestMessage.create(:request_id => @request.id,
                                                    :message_id => message_id)
            message = Message.find(message_id)
            assigner_id = message.employee_id ? message.employee_id : @request.registrar_id
            message.tasks.each { |task|
              request_task = RequestTask.create(:assigner_id => assigner_id,
                                                :auditor_id  => assigner_id,
                                                :task_id => task.id,
                                                :request_message_id => request_message.id,
                                                :creation_date => Time.now,
                                                :deadline_date => task.deadline.days.from_now)
            }
          }
        end
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.js   {}
        format.json { render json: @request, status: :created, location: @request }
      else
        format.html { render action: 'index' }
        format.js   {}
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        
        format.js   {}
        format.json { render json: @request, status: :created, location: @request }
      else
        format.html { render action: 'edit' }
        format.js   {}
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @requests = Request.all
    
    @request.destroy
    respond_to do |format|
      format.html { redirect_to requests_url }
      format.js   {}
      format.json { head :no_content }
    end
  end

  def messages_for_request
    request_type = params[:request_type]

    @messages = Message.where(:request_type => request_type)

    render template: "/requests/messages_for_request.html.erb"
  end

  def request_group_destroy
    @request_ids = params[:for_destroy]
    Request.where(:id => @request_ids).destroy_all

    respond_to do |format|
      format.js {}
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
      params.require(:request).permit(:machine_id, :description, :request_type, :phone)
    end
end
