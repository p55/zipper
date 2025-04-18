# frozen_string_literal: true

FactoryBot.define do
  factory :zip_archive do
    user { build(:user) }
    uuid { SecureRandom.uuid }
    original_filename { "test_file.pdf" }
    file_path { "#{uuid}.zip" }

    trait(:with_physical_file) do
      after(:create) do |archive|
        dir_path = archive.user.zip_archives_dir_path
        zip_path = File.join(dir_path, "#{archive.uuid}.zip")

        FileUtils.mkdir_p(dir_path)
        FileUtils.touch(zip_path)

        archive.update!(file_path: zip_path)
      end
    end
  end
end
