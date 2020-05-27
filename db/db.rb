# frozen_string_literal: true

require 'sequel'
require 'sqlite3'

class Database
  attr_reader :table, :db, :dataset
  def initialize(group_id:)
    @table = group_id
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
      String :coutry
      String :city
      String :bdate
    end
    db[table]
  end

  public

  def write_down(users)
    users.each do |user|
      dataset.insert(user_id: user['bdate']) unless user['bdate'].nil?
      dataset.insert(city: user['city']['title']) unless user['city'].nil?
      dataset.insert(country: user['country']['title']) unless user['country'].nil?
      dataset.insert(name_surname: user['first_name'] + ' ' + user['last_name'])
      dataset.insert(user_id: user['id']) unless user['id'].nil?
    end
  end
end
