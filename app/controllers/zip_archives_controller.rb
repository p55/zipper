# frozen_string_literal: true

class ZipArchivesController < ApplicationController
  def download
    archive = ZipArchive.find_by(uuid: params[:uuid])

    if archive.nil? || !File.exist?(archive.file_path)
      return render json: { error: "File not found" }, status: :not_found
    end

    real_path = File.expand_path(archive.file_path)
    unless real_path.start_with?(archive.user.zip_archives_dir_path)
      Rails.logger.warn("Unauthorized file access attempt: #{real_path}")
      return render json: { error: "Forbidden" }, status: :forbidden
    end

    send_file real_path,
      filename: File.basename(real_path),
      type: "application/zip",
      disposition: "attachment"
  end
end
