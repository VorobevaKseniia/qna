class AddUserIdToAnswer < ActiveRecord::Migration[6.1]
  def change
    add_reference :answers, :user, foreign_key: { on_delete: :cascade }
  end
end
