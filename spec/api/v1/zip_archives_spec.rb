# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Zip archives', type: :request do
  include ActionDispatch::TestProcess::FixtureFile

  describe 'POST /api/v1/zip_archives' do
    let(:file) { fixture_file_upload('test.txt') }

    context 'no token is provided' do
      it 'returns 401' do
        post '/api/v1/zip_archives',
        params: { file: file },
        headers: {}

        expect(response.status).to eq(401)
      end
    end

    context 'invalid token is provided' do
      it 'returns 401' do
        post '/api/v1/zip_archives',
        params: { file: file },
        headers: { 'Authorization' => "Bearer #{SecureRandom.hex}" }

        expect(response.status).to eq(401)
      end
    end

    context 'valid token is provided' do
      let(:user) { create(:user) }
      after { FileUtils.rm_rf(user.zip_archives_dir_path) }

      it 'creates zip archive and returns download link with password' do
        token = V1::Services::GenerateToken.call(user: user)
        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }

        expect do
          post '/api/v1/zip_archives',
          params: { file: file },
          headers: headers
        end.to change { user.reload.zip_archives.count }.by(1)

        archive = user.zip_archives.last
        expect(parsed_response(response)[:download_link])
          .to eq(Rails.application.routes.url_helpers.download_zip_archive_url(uuid: archive.uuid))
        expect(parsed_response(response)[:password]).to match(/\A[a-f0-9]{24}\z/)
      end
    end
  end

  describe 'GET /api/v1/zip_archives' do
    context 'no token is provided' do
      it_behaves_like '401 unauthorized', 'get', '/api/v1/zip_archives'
    end

    context 'invalid token is provided' do
      it_behaves_like(
        '401 unauthorized',
        'get',
        '/api/v1/zip_archives',
        headers: { 'Authorization' => "Bearer #{SecureRandom.hex}" }
      )
    end

    context 'valid token is provided' do
      it 'returns list of archives with pagination' do
        user = create(:user)
        archive = create(:zip_archive, user: user)
        token = V1::Services::GenerateToken.call(user: user)
        headers = {
          'Accept' => 'application/json',
          'Authorization' => "Bearer #{token}"
        }

        get '/api/v1/zip_archives', headers: headers

        expect(response).to be_successful
        expect(response.content_type).to eq('application/json')

        parsed = parsed_response(response)

        expect(parsed[:zip_archives]).to be_an(Array)
        expect(parsed[:zip_archives][0]).to eq(
          V1::Entities::ZipArchive.represent(archive, serializable: true).as_json.deep_symbolize_keys
        )

        expect(parsed[:pagination]).to eq(
          {
            current_page: 1,
            total_pages: 1,
            total_count: 1
          }
        )
      end
    end
  end
end
