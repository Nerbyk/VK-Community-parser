# frozen_string_literal: true

require 'yaml'
require 'singleton'

class GetMessageText
  attr_reader :replies_list, :case_text
  include Singleton
  def initialize
    @replies_list = YAML.safe_load(File.read('./msg-to-send/messages.yaml'))
  end

  def reply(case_text)
    replies_list[case_text]
  end
end
