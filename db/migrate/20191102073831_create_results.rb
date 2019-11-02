class CreateResults < ActiveRecord::Migration[5.2]
  def change
    create_table :results do |t|
      t.integer :r_id
      t.text :text

      t.timestamps
    end
  end
end
