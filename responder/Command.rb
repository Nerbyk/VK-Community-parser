# frozen_string_literal: true

require './bot_options.rb'
require './responder/ExpectedInput.rb'
require './parser/UsersParser.rb'
class Invoker
  def execute(cmd)
    @history ||= []
    @history << cmd.execute
  end
end

class Command
  attr_reader :request

  def initialize(request)
    @request = request
  end

  def execute
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}"
  end
end

class StartCommand < Command
  def execute
    request.start
  end
end

class LinkCommand < Command
  def execute
    request.link
  end
end

class Receiver
  def start
    BotOptions.instance.send_message(text: 'start_message')
  end

  def link
    GetUsersList.new(BotOptions.instance.message.text)
  end
end

class AnswerClient
  def initialize
    @receiver = Receiver.new
    @invoker = Invoker.new
  end

  def respond_to(cmd)
    case cmd
    when Input::START then @invoker.execute(StartCommand.new(@receiver))
    when /#{Input::LINK}/ then @invoker.execute(LinkCommand.new(@receiver))
    end
  end
end
