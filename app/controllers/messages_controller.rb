class MessagesController < ApplicationController
  include ActionController::Live

  def events
    response.headers["Content-Type"] = "text/event-stream"
    uri = URI.parse(ENV["REDISTOGO_URL"] || "redis://localhost:6379/")
    redis = Redis.new(:url => uri)

    redis.subscribe('messages.create') do |on|
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
    @new_username = RandomUsername.username
  end

  # POST /messages
  def create
    @message = Message.create!(message_params)
    $redis.publish('messages.create', @message.to_json)
    render nothing: true
  end

  private
    # Only allow a trusted parameter "white list" through.
    def message_params
      params.require(:message).permit(:user_id, :body)
    end
end
