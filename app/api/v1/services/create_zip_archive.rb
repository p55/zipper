module V1
  module Services
    class CreateZipArchive < Service
      EncryptionError = Class.new(StandardError)

      def call(file_params:, user:)
        @user = user
        @filename = sanitize_filename(file_params[:filename])
        @tempfile = file_params[:tempfile]
        @password = SecureRandom.hex(12)
        @uuid = SecureRandom.uuid

        prepare_user_dir!
        temp_path = copy_temp_file
        zip_path = build_zip_path

        zip_file(temp_path, zip_path)

        FileUtils.rm(temp_path)

        {
          zip_archive: create_archive(zip_path),
          password: @password
        }
      end

      private

      def sanitize_filename(filename)
        filename.gsub(/[^0-9A-Za-z.\-_]/, "_")
      end

      def prepare_user_dir!
        FileUtils.mkdir_p(@user.zip_archives_dir_path) unless Dir.exist?(@user.zip_archives_dir_path)
      end

      def copy_temp_file
        temp_file_copy_path = Rails.root.join("tmp", @filename)
        FileUtils.cp(@tempfile.path, temp_file_copy_path)
        temp_file_copy_path
      end

      def build_zip_path
        File.join(@user.zip_archives_dir_path, "#{@uuid}.zip")
      end

      def zip_file(input_path, output_path)
        Dir.chdir(File.dirname(input_path)) do
          stdout, stderr, status = Open3.capture3("zip -j -P #{@password} #{output_path} \"#{@filename}\"")
          raise EncryptionError, "Zip failed: #{stderr}" unless status.success?
        end
      end

      def create_archive(path)
        @user.zip_archives.create!(
          uuid: @uuid,
          file_path: path,
          original_filename: @filename
        )
      end
    end
  end
end
