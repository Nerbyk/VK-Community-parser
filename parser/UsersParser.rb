# frozen_string_literal: true

# require 'requests/sugar'
require './db/db.rb'
require 'dotenv'
require 'vkontakte_api'
Dotenv.load('./.env')

class ApiInfo
  attr_reader :token, :version, :group_id
  def initialize(group_id)
    @token = ENV['VK_TOKEN']
    @version = ENV['VK_API_VERSION']
    @group_id = group_id
    execute
  end

  protected

  def execute
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}"
  end
end

class GetUsersList < ApiInfo
  attr_reader :token, :version, :group_id
  def execute
    users = []
    limit = 1000
    page = 0
    @vk = VkontakteApi::Client.new(token)
    @group_id = group_id.split('/').last
    loop do
      offset = page * limit
      members = @vk.groups.getMembers("group_id": group_id, "v": version, "fields": 'sex, bdate, city, country', "offset": offset)
      members.items.each { |user| users << user }
      page += 1
      break if members['count'].to_i < offset + limit
    end
    db = Database.new(group_id: group_id)
    db.write_down(users)
  end
end
