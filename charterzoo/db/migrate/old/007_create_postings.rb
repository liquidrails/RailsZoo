class CreatePostings < ActiveRecord::Migration
  def self.up
    create_table :postings do |t|
      t.string :headline
      t.text :details
      t.string :organizer
      t.string :contact
      t.string :link
      t.string :email
      t.date :departure
      t.date :return
      t.integer :duration
      t.integer :subcategory_id
      t.string :phone
      t.integer :catch_all
      t.string :key
      t.boolean :validated

      t.timestamps
    end
  end

  def self.down
    drop_table :postings
  end
end
