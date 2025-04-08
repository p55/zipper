# frozen_string_literal: true

require 'rails_helper'

RSpec.describe V1::Services::CreateZipArchive do
  describe '.call' do
    let(:user) { create(:user) }
    let(:file) { fixture_file_upload('test.txt') }

    it 'creates encrypted zip file and archive record' do
      result = described_class.call(
        file_params: {
          filename: file.original_filename,
          tempfile: file.tempfile
        },
        user: user
      )

      expect(result[:zip_archive]).to be_a(ZipArchive)
      expect(File.exist?(result[:zip_archive].file_path)).to eq(true)
      expect(result[:password]).to match(/\A[a-f0-9]{24}\z/)
    ensure
      FileUtils.rm_rf(user.zip_archives_dir_path)
    end
  end
end
