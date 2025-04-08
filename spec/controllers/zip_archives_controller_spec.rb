require 'rails_helper'

RSpec.describe "ZipArchives", type: :request do
  describe "GET /zip_archives/:uuid/download" do
    subject(:download_request) { get download_zip_archive_path(uuid: archive_uuid) }

    context "when zip archive record does not exist" do
      let(:archive_uuid) { "nonexistent-uuid" }

      it "returns a not found response" do
        download_request

        expect(response).to have_http_status(:not_found)
        expect(response.body).to include("File not found")
      end
    end

    context "when zip archive exists" do
      context "but zip file does not exist" do
        let!(:archive) { create(:zip_archive) }
        let(:archive_uuid) { archive.uuid }

        it "returns a not found response" do
          download_request

          expect(response).to have_http_status(:not_found)
          expect(response.body).to include("File not found")
        end
      end

      context "and zip file exists" do
        let!(:archive) { create(:zip_archive, :with_physical_file) }
        let(:archive_uuid) { archive.uuid }

        after do
          FileUtils.rm_rf(archive.file_path) if File.exist?(archive.file_path)
        end

        it "returns the zip file" do
          download_request

          expect(response).to have_http_status(:ok)
          expect(response.headers['Content-Type']).to eq("application/zip")
          expect(response.headers['Content-Disposition']).to include("attachment")
        end
      end

      context "but file path is outside user directory" do
        let!(:archive) { create(:zip_archive, file_path: "/etc/passwd") }
        let(:archive_uuid) { archive.uuid }

        it "returns a forbidden response" do
          download_request

          expect(response).to have_http_status(:forbidden)
          expect(response.body).to include("Forbidden")
        end
      end
    end
  end
end
