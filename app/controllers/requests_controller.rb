class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :signed_in_user

  respond_to :html, :json

  # GET /requests
  # GET /requests.json 
  def index
    @ng_controller = "Requests"

    parm = params.dup
    parm[:signed_in] = signed_in?
    parm[:current_employee] = current_user.employee
    page_num = params[:page] || 1

    respond_to do |format|
      format.html { }
      format.json { render json: Request.page(page_num, parm).collect { |r| r.attrs } }
    end
  end

  def count
    parm = params.dup
    parm[:signed_in] = signed_in?
    parm[:current_employee] = current_user.employee

    respond_with Request.filter(parm).size
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
    message_ids = params[:messages]

    if @request.save
      # Если были переданы идентификаторы сигналов, которые нужно породить
      if message_ids
        employees = {} # Сохраним сюда сотрудников, фигурирующих в поручениях
        sms_codes = {} # Сохраним сюда коды подтверждения сотрудников, которые нужно отослать

        # Породим каждый сигнал
        message_ids.each { |m|
          request_message = RequestMessage.create(:request_id => @request.id,
                                                  :message_id => m[:id])
          message = Message.find(m[:id])
          # Для каждого сигнала созданим поручения заявок
          message.tasks.each { |task|
            assigner_id = task.solver ? task.solver_id : @request.registrar_id
            assigner = Employee.find(assigner_id)
            employees[assigner_id] = assigner
            next_sms_code = assigner.get_next_sms_code

            request_task = RequestTask.create(:assigner_id => assigner_id,
                                              :auditor_id  => assigner_id,
                                              :task_id => task.id,
                                              :request_message_id => request_message.id,
                                              :creation_date => DateTime.now,
                                              :deadline_date => DateTime.now + task.deadline.days,
                                              :registrar_description => message.description,
                                              :email_to_assigner_date => DateTime.now,
                                              :assigner_sms_code => next_sms_code)

            # Сохраним использованный код подтверждения для отправки его через смс
            if sms_codes[assigner_id]
              if next_sms_code < sms_codes[assigner_id]
                sms_codes[assigner_id] = next_sms_code
              end
            else
              sms_codes[assigner_id] = next_sms_code
            end
          }

          # Создадим атрибуты, если есть информация о них
          if m[:attributes]
            m[:attributes].each { |a|
              request_attribute = RequestAttribute.create(:request_message_id => request_message.id,
                                                          :attribute_id => a[:id],
                                                          :value => a[:value])
            }
          end
        }

        # Каждому сотруднику их поручений отошлем письма, что они назначатели
        employees.each { |key, employee|
          params = {
            :host => request.host_with_port,
            :request => @request,
            :sms_code => sms_codes[key]
          }
          employee.send_assign_email(params)
          employee.send_assign_sms(params)
        }
      end
      respond_to do |format|
          format.json { render json: @request.attrs, status: :created }
      end
    else
      respond_to do |format|
          format.json { render json: @request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requests/1
  # PATCH/PUT /requests/1.json
  def update
    respond_to do |format|
      if @request.update(request_params)
        format.json { render json: @request.attrs, status: :created }
      else
        format.json { render json: @request.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requests/1
  # DELETE /requests/1.json
  def destroy
    @request.destroy
    respond_to do |format|
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
