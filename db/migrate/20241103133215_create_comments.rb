class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.belongs_to :commentable, polymorphic: true, null: false
      t.references :user, foreign_key: { on_delete: :cascade }, null: false
      t.text :body

      t.timestamps
    end
  end
end
