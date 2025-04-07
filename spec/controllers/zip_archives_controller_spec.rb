require 'rails_helper'

RSpec.describe "ZipArchives", type: :request do
  describe "GET /zip_archives/:uuid/download" do
    context "when zip archive record does not exist" do
      it "returns a not found response" do
        get download_zip_archive_path(uuid: "nonexistent-uuid")

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("File not found")
      end
    end

    context "when zip archive record exists" do
      let(:archive) { create(:zip_archive) }

      context "when zip file does not exit" do
        it "returns not found response" do
          get download_zip_archive_path(uuid: archive.uuid)

          expect(response).to have_http_status(:not_found)
          expect(response.body).to include("File not found")
        end
      end

      context "when zip file exists" do
        let(:archive) { create(:zip_archive, :with_physical_file) }
        after { FileUtils.rm_r(archive.file_path) }

        it "returns the zip file" do
          get download_zip_archive_path(uuid: archive.uuid)

          expect(response).to have_http_status(:ok)
          expect(response.headers['Content-Type']).to eq("application/zip")
          expect(response.headers['Content-Disposition']).to include("attachment")
        end
      end
    end
  end
end
