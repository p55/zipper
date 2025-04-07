FactoryBot.define do
  factory :zip_archive do
    user { build(:user) }
    uuid { SecureRandom.uuid }
    original_filename { "test_file.pdf" }
    file_path { "#{uuid}.zip" }

    trait(:with_physical_file) do
      after(:create) do |archive|
        FileUtils.mkdir_p(archive.user.zip_archives_dir_path)
        system("cd #{archive.user.zip_archives_dir_path} && touch #{archive.uuid}.zip")
        archive.update!(file_path: File.join(archive.user.zip_archives_dir_path, archive.file_path))
      end
    end
  end
end
