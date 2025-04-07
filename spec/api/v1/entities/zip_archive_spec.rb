require 'rails_helper'

RSpec.describe V1::Entities::ZipArchive, type: :entity do
  describe '.represent' do
    it 'exposes user attributes' do
      archive = build(:zip_archive)

      expect(
        described_class.represent(archive).as_json
      ).to eq({
        id: archive.id,
        original_filename: archive.original_filename,
        download_url: Rails.application.routes.url_helpers.download_zip_archive_url(uuid: archive.uuid),
        created_at: archive.created_at
      })
    end
  end
end
