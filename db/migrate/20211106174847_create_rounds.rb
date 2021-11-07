class CreateRounds < ActiveRecord::Migration[6.1]
  def change
    create_table :rounds do |t|
      t.string :name
      t.string :scores, array: true, default: Array.new(30) { '-1' }

      t.timestamps
    end
  end
end
