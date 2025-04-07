module V1
  module Entities
    class ZipArchive < Grape::Entity
      expose :id, documentation: { type: "Integer", example: 1234 }
      expose :original_filename, documentation: { type: "String", example: "test.pdf" }
      expose :created_at, documentation: { type: "DateTime", example: "2025-04-07T10:00:00Z" }
      expose :download_url,
        documentation: { type: "String", example: "http://localhost:3000/zip_archives/uuid/download" } do |zip_archive|
        Rails.application.routes.url_helpers.download_zip_archive_url(uuid: zip_archive.uuid)
      end
    end
  end
end
