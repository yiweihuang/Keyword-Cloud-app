require 'http'

class CreateFolder
  def self.call(uid:, auth_token:, cid:, folder_url:, folder_type:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .post("#{ENV['API_HOST']}/accounts/#{uid}/#{cid}/#{folder_type}/",
                         json: {folder_url: folder_url})
    response.code == 201 ? response.parse : nil
  end
end
