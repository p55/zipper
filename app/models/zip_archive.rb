# frozen_string_literal: true

class ZipArchive < ApplicationRecord
  DIR_NAME = "zip_archives".freeze

  belongs_to :user

  validates :file_path, presence: true
  validates :uuid, presence: true
  validates :original_filename, presence: true
  validates :user, presence: true
end
