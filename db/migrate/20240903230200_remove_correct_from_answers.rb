# frozen_string_literal: true

class RemoveCorrectFromAnswers < ActiveRecord::Migration[6.1]
  def change
    remove_column :answers, :correct, :boolean
  end
end
