# frozen_string_literal: true

require 'requests/sugar'
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
    @group_id = group_id.split('/').last
    # response = Requests.get('https://api.vk.com/method/groups.getMembers', params: { 'access_token': token,
    #                                                                                  'v': version,
    #                                                                                  'group_id': group_id }).json['response']
    # p response
    # count = response['count']
    # members = response['items']
    # offset = 1000
    # while offset < count
    #   response = Requests.get('https://api.vk.com/method/groups.getMembers', params: { 'access_token': token,
    #                                                                                    'v': version,
    #                                                                                    'group_id': group_id,
    #                                                                                    'count': offset.to_i,
    #                                                                                    'offset': offset.to_i }).json['response']
    #   p response
    #   offset = response['offset']
    #   members += response['items']
    # end
    # p members
    # # r = Requests.get('https://api.vk.com/method/users.get', params: {'access_token': token, 'v': v, 'user_ids': @link, 'fields': 'id' })
    # # vk_id = r.json['response']
    # # @link = vk_id[0]['id']
    @vk = VkontakteApi.authorize(code: token)
    p @vk.friends.get
  end
end

GetUsersList.new('https://vk.com/pozor.brno')
