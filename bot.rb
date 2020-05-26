# frozen_string_literal: true

require 'singleton'
require 'telegram/bot'
require 'dotenv'
require 'logger'
require './msg-to-send/get_message.rb'
require './bot_options.rb'
require './responder/Responder.rb'

Dotenv.load('./.env')

prs_log = Logger.new('./logs/prs_error.log', 'monthly')
ui_log  = Logger.new('./logs/user_input.log', 'monthly')

Telegram::Bot::Client.run(ENV['TOKEN']) do |bot|
  bot_opt = BotOptions.instance
  bot_opt.bot = bot
  bot.listen do |message|
    bot_opt.message = message
    begin
      message_responder = MessageResponder.new
      ui_log.debug("User id = #{message.from.id}, UserName = #{message.from.username}, message = #{message.text}")
    rescue StandardError => e
      BotOptions.instance.send_message(text: 'error_occured')
      prs_log.error("User_id #{message.from.id}, User name = #{message.from.username} Error = #{e}")
      p e
    end
  end
end
