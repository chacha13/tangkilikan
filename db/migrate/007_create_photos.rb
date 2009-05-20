class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.string   "caption",    :limit => 1000
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "profile_id"
      t.string   "image"
    end
    
    add_index 'photos', 'profile_id'
    
    end

  def self.down
    drop_table :photos
  end
end
