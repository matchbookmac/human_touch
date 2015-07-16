class MessagesController < ApplicationController
  include ActionController::Live

  before_action :set_message, only: [:show, :edit, :update, :destroy]


  def events
    response.headers["Content-Type"] = "text/event-stream"
    start = Time.zone.now
    redis = Redis.new
    REDIS.subscribe('messages.create') do |on|
      on.message do |event, data|
        response.stream.write("data: #{data }\n\n")
      end
    end

    rescue IOError
    logger.info "Stream closed"
    ensure
    redis.quit
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
    @message = current_user.messages.create!(message_params)
    username = {'username' => current_user.username}
    json = @message.as_json
    json = json.merge(username)
    redis = Redis.new
    REDIS.publish('messages.create', json.to_json)
    render nothing: true
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
