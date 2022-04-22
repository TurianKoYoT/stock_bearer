class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :name, null: false
      t.datetime :deleted_at

      t.belongs_to :bearer, null: false

      t.timestamps

      t.index :name, unique: true
    end
  end
end
