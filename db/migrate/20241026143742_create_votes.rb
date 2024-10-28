class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.belongs_to :votable, polymorphic: true, null: false
      t.references :user, foreign_key: { on_delete: :cascade }, null: false
      t.integer :value, null: false

      t.timestamps
    end
  end
end
