# frozen_string_literal: true

module V1
  class ZipArchives < Base
    namespace :zip_archives do
      desc "Create encrypted zip archive" do
        consumes [ "multipart/form-data" ]
        security [ { Bearer: [] } ]
        success code: 200, message: "Archive created", examples: {
          "application/json" => {
            download_link: "http://localhost:3000/zip_archives/uuid/download",
            password: "example_password"
          }
        }
        failure [
          { code: 401, message: "Unauthorized" }
        ]
        tags [ "Zip Archives" ]
      end
      params do
        requires :file, type: File, desc: "File to upload"
      end
      post do
        authenticate!

        result = V1::Services::CreateZipArchive.call(file_params: params[:file], user: current_user)
        download_link = Rails.application.routes.url_helpers.download_zip_archive_url(
          uuid: result[:zip_archive].uuid
        )
        { download_link: download_link, password: result[:password] }
      end

      desc "Return paginated list of user zip archives" do
        security [ { Bearer: [] } ]
        success code: 200, message: "Returns zip archives list with pagination", examples: {
          "application/json" => {
            zip_archives: [
              {
                uuid: "abc123",
                original_filename: "test.txt",
                created_at: "2025-04-07T12:34:56Z"
              }
            ],
            pagination: {
              current_page: 1,
              total_pages: 1,
              total_count: 1
            }
          }
        }
        failure [
          { code: 401, message: "Unauthorized" }
        ]
        tags [ "Zip Archives" ]
      end
      params do
        optional :page, type: Integer, default: 1, desc: "Page number"
        optional :per_page, type: Integer, default: 10, values: 1..100, desc: "Records per page (max 100)"
      end
      get do
        authenticate!

        zip_archives = current_user.zip_archives.order(created_at: :desc).page(params[:page]).per(params[:per_page])
        {
          zip_archives: V1::Entities::ZipArchive.represent(zip_archives, serializable: true),
          pagination: {
            current_page: zip_archives.current_page,
            total_pages: zip_archives.total_pages,
            total_count: zip_archives.total_count
          }
        }
      end
    end
  end
end
