# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#zip_archive_dir_path' do
    it 'returns zip archive dir path' do
      user = create(:user)

      expect(user.zip_archives_dir_path).to eq(
        File.join(Rails.root, ZipArchive::DIR_NAME, user.id.to_s)
      )
    end
  end
end
