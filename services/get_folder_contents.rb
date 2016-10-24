require 'http'

class GetFolderContents
  def self.call(current_uid:, auth_token:, course_id:, folder_id:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/accounts/#{current_uid}/#{course_id}/folders/#{folder_id}")
    response.code == 200 ? folder_contents(response.parse) : []
  end

  private

  def self.folder_contents(content)
    c = content['data'].map do |info|
      { file_id: info['id'],
        filename: info['data']['filename'],
        video_id: info['data']['video_id'],
        document_encrypted: info['data']['document_encrypted'],
        checksum: info['data']['checksum']}
    end

    {
      course_id: content['course_id'],
      folder_name: content['folder_name'],
      folder_id: content['folder_id'],
      folder_type: content['folder_type'],
      files: c
    }
  end
end
