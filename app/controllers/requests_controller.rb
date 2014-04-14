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
        messages.each { |m|
          request_message = RequestMessage.create(:request_id => @request.id,
                                                  :message_id => m[:id])
          message = Message.find(m[:id])
          assigner_id = message.employee_id ? message.employee_id : @request.registrar_id
          message.tasks.each { |task|
            request_task = RequestTask.create(:assigner_id => assigner_id,
                                              :auditor_id  => assigner_id,
                                              :task_id => task.id,
                                              :request_message_id => request_message.id,
                                              :creation_date => Time.now,
                                              :deadline_date => task.deadline.days.from_now)
          }

          if m[:attributes]
            m[:attributes].each { |a|
              request_attribute = RequestAttribute.create(:request_message_id => request_message.id,
                                                          :attribute_id => a[:id],
                                                          :value => a[:value])
            }
          end
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
      params.require(:request).permit(:machine_id, :description, :request_type, :phone)
    end
end
