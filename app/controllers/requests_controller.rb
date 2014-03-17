class RequestsController < ApplicationController
  before_action :set_request, only: [:show, :edit, :update, :destroy, :request_messages]

  # GET /requests
  # GET /requests.json 
  def index
    @requests = Request.all
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
    messages = params[:messages]

    respond_to do |format|
      if @request.save
        if messages
          messages.each { |message|
            RequestMessage.create(:request_id => @request.id, :message_id => message);
          }
        end
        format.html { redirect_to @request, notice: 'Request was successfully created.' }
        format.js   {}
        format.json { render json: @request, status: :created, location: @request }
      else
        format.html { render action: 'new' }
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
        format.html { redirect_to @request, notice: 'Request was successfully updated.' }
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

  def request_messages
    @request_messages = RequestMessage.where(:request_id => @request.id)

    render template: "/requests/request_messages.html.erb"
  end

  def messages_for_request
    request_type = params[:request_type]

    @messages = Message.where(:request_type => request_type)

    render template: "/requests/messages_for_request.html.erb"
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
