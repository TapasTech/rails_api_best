# frozen_string_literal: true

class CreateEditors < ActiveRecord::Migration[6.0]
  def change
    create_table :editors do |t|
      t.string :telephone
      t.string :username
      t.string :password_digest
      t.string :auth_token
      t.date :last_login_at

      t.timestamps
    end
  end
end
