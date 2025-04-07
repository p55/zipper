module V1
  class ZipArchives < Base
    namespace :zip_archives do
      desc "Create encrypted zip archive"
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

      desc "Return list of all user zip archives"
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
