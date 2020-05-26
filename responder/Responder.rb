# frozen_string_literal: true

require './responder/Command.rb'
class MessageResponder
  def initialize
    respond
  end

  private

  def respond
    AnswerClient.new.respond_to(BotOptions.instance.message.text)
  end
end
