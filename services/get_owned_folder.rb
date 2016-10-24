require 'http'

class GetOwnedFolder
  def self.call(current_uid:, auth_token:, course_id:, folder_type:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/accounts/#{current_uid}/#{course_id}/#{folder_type}")
    response.code == 200 ? new_folder(response.parse) : []
  end

  private

  def self.new_folder(chapter)
    chapter['data'].map do |info|
      { folder_id: info['id'],
        course_id: info['data']['course_id'],
        folder_type: info['data']['folder_type'],
        chapter_order: info['data']['chapter_order'],
        chapter_id: info['data']['chapter_id'],
        name: info['data']['name'],
        folder_url: info['data']['folder_url_encrypted']}
    end
  end
end
