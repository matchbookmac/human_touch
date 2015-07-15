class MessagesController < ApplicationController
  include ActionController::Live

  before_action :set_message, only: [:show, :edit, :update, :destroy]

  def events
    response.headers["Content-Type"] = "text/event-stream"
    start = Time.zone.now
    10.times do |n|
      Message.uncached do
        Message.where('created_at > ?', start).each do |message|
          # binding.pry
          response.stream.write "data: #{message.to_json}\n\n"
          start = Time.zone.now
        end
      end
      sleep 2
    end

    rescue IOError
    logger.info "Stream closed"
    ensure
    response.stream.close
  end

  # GET /messages
  def index
    @messages = Message.all
  end

  # GET /messages/1
  def show
  end

  # GET /messages/new
  def new
    @message = Message.new
  end

  # GET /messages/1/edit
  def edit
  end

  # POST /messages
  def create
    @message = Message.create(message_params)
    render :index
  end

  # PATCH/PUT /messages/1
  def update
    if @message.update(message_params)
      redirect_to @message, notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /messages/1
  def destroy
    @message.destroy
    redirect_to messages_url, notice: 'Message was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_message
      @message = Message.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:user_id, :body)
    end
end
