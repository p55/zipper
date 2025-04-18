# frozen_string_literal: true

class CreateZipArchives < ActiveRecord::Migration[8.0]
  def change
    create_table :zip_archives do |t|
      t.references :user, null: false, foreign_key: true
      t.string :file_path, null: false, default: ""
      t.string :uuid, null: false
      t.string :original_filename, null: false, default: ""

      t.timestamps
    end
    add_index :zip_archives, :uuid, unique: true
  end
end
