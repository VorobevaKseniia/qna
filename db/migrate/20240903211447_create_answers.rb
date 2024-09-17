# frozen_string_literal: true

class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.text :body
      t.boolean :correct, default: false
      t.references :question, foreign_key: true, null: false

      t.timestamps
    end
  end
end
