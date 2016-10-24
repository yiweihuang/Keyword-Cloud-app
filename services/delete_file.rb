require 'http'

class DeleteFile
  def self.call(current_uid:, auth_token:, course_id:, folder_id:, filename:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .delete("#{ENV['API_HOST']}/accounts/#{current_uid}/#{course_id}/folders/#{folder_id}/files/?",
                         json: {filename: filename})
    response.code == 201 ? response.parse : nil
  end
end
