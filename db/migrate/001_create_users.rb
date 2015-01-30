class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string  :name,      uniqueness: true
      t.integer :uid,        uniqueness: true
      t.boolean :banned,    default:    false
      t.string  :password
      t.timestamps          null:       true
    end
  end

  def self.down
    drop_table :users
  end
end
