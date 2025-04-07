module V1
  module Entities
    class ZipArchive < Grape::Entity
      expose :id, :original_filename, :created_at
      expose :download_url do |zip_archive|
        Rails.application.routes.url_helpers.download_zip_archive_url(uuid: zip_archive.uuid)
      end
    end
  end
end
