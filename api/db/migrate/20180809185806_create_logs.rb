class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.string :component_name
      t.string :component_type
      t.string :location
      t.string :status
      t.bigint :change_ts
    end
  end
end
