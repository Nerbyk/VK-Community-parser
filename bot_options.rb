# frozen_string_literal: true

require './msg-to-send/get_message.rb'

class BotOptions
  attr_accessor :bot, :message
  include Singleton
  def initialize
    @bot = bot
    @message = message
  end

  def send_message(text:, markup: nil)
    bot.api.send_message(chat_id: message.from.id, text: GetMessageText.instance.reply(text), reply_markup: markup)
  end

  def delete_markup
    bot.api.reply_keyboard_remove(remove_keyboard: true)
  end
end
