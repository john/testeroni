class CreateVideos < ActiveRecord::Migration[6.0]
  def self.up
    create_table :videos do |t|
      t.integer :tst_id
      t.integer :question_id
      t.string :name
      t.string :description
      t.integer :status, :limit => 1
      t.string :provider      # youtube, ted, etc
      t.string :url           # ie, http://www.youtube.com/watch?v=W0VWO4asgmk
      t.string :provider_id   # unique id of video on providers site, ie W0VWO4asgmk
      t.timestamps
    end
    add_index :videos, :tst_id
    add_index :videos, :question_id
  end

  def self.down
    drop_table :videos
  end
end
