# frozen_string_literal: true

require 'sequel'
require 'sqlite3'

class Database
  attr_reader :table, :db, :dataset
  def initialize(group_id:)
    @table = group_id.to_sym
    @db = Sequel.sqlite('./db/groups.db')
    @dataset = create
  end

  private

  def create
    db.create_table? table do
      primary_key :id
      String :user_id
      String :name_surname
      String :sex
      String :country
      String :city
      String :bdate
    end
    db[table]
  end

  public

  def write_down(users)
    i = 1
    users.each do |user|
      user = check_for_nils(user)
      insert_data(user_id: 'http://vk.com/id' + user['id'].to_s, name_surname: user['first_name'] + ' ' + user['last_name'], sex: user['sex'], country: user['country']['title'], city: user['city']['title'], bdate: user['bdate'])
      # dataset.where(user_id: user['id']).update(name_surname: user['first_name'] + ' ' + user['last_name'])
      # dataset.where(user_id: user['id']).update(sex: user['sex']) unless user['sex'].nil?
      # dataset.where(user_id: user['id']).update(country: user['country']['title']) unless user['country'].nil?
      # dataset.where(user_id: user['id']).update(city: user['city']['title']) unless user['city'].nil?
      # dataset.where(user_id: user['id']).update(bdate: user['bdate']) unless user['id'].nil?
      i += 1
      if i == 10 * users.length / 100
        puts '10%'
      elsif i == 25 * users.length / 100
        puts '25%'
      elsif i == 50 * users.length / 100
        puts '50%'
      elsif i == 75 * users.length / 100
        puts '75%'
      elsif i == 90 * users.length / 100
        puts '90%'
      end
    end
    puts 'passed'
  end

  private

  def insert_data(user_id:, name_surname:, sex:, country:, city:, bdate:)
    dataset.insert(user_id: user_id, name_surname: name_surname, sex: sex, country: country, city: city, bdate: bdate)
  end

  def check_for_nils(user)
    user['bdate'] = 'n/a' unless user.key?('bdate')
    user['sex']   = 'n/a' unless user.key?('sex')
    user['country'] = 'n/a' unless user.key?('country')
    user['city'] = 'n/a' unless user.key?('city')
    user
  end
end
