# frozen_string_literal: true

class AddMissingIndexes < ActiveRecord::Migration[7.0]
  def change
    add_index :companies, :name
    add_index :companies, :industry
    add_index :companies, :created_at
    add_index :companies, :employee_count
  end
end
