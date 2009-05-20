class CreateFaqs < ActiveRecord::Migration
def self.up
create_table :faqs do |t|
t.column :user_id, :integer, :null => false
t.column :bio, :text
t.column :skills, :text
t.column :schools, :text
t.column :companies, :text
t.column :music, :text
t.column :movies, :text
t.column :television, :text
t.column :magazines, :text
t.column :books, :text
end
end
def self.down
drop_table :faqs
end
end