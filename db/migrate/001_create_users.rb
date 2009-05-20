class CreateUsers < ActiveRecord::Migration
def self.up
create_table :users do |t|
t.column :user_name, :string
t.column :email, :string
t.column :password, :string
end
end
def self.down
drop_table :users
end
end