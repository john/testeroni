class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.integer :test_id
      t.integer :question_id
      t.string :name
      t.string :description
      t.integer :status, :limit => 3
      t.string :provider      # youtube, ted, etc
      t.string :url           # ie, http://www.youtube.com/watch?v=W0VWO4asgmk
      t.string :provider_id   # unique id of video on providers site, ie W0VWO4asgmk
      t.timestamps
    end
    add_index :videos, :test_id
    add_index :videos, :question_id
  end

  def self.down
    drop_table :videos
  end
end
