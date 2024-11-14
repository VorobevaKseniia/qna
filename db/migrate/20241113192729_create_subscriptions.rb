class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.references :question, null: false, foreign_key: { on_delete: :cascade }

      t.timestamps
    end
  end
end
