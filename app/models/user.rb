class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable, :validatable,
         :recoverable, :jwt_authenticatable, jwt_revocation_strategy: self

  has_many :zip_archives

  def zip_archives_dir_path
    File.join(Rails.root, ZipArchive::DIR_NAME, id.to_s)
  end
end
