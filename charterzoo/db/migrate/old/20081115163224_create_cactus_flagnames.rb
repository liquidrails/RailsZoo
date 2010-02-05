class CreateCactusFlagnames < ActiveRecord::Migration
  def self.up
    create_table :cactus_flagnames do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :cactus_flagnames
  end
end
