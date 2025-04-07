class ZipArchivesController < ApplicationController
  def download
    zip_archive = ZipArchive.find_by(uuid: params[:uuid])

    if zip_archive.nil? || !File.exist?(zip_archive.file_path)
      render json: { error: "File not found" }, status: :not_found
      return
    end

    send_file zip_archive.file_path,
      filename: File.basename(zip_archive.file_path),
      type: "application/zip",
      disposition: "attachment"
  end
end
