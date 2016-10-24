require 'http'

class GetKeywordContents
  def self.call(current_uid:, auth_token:, course_id:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/accounts/#{current_uid}/#{course_id}/folders/slides/segment")
    response.code == 200 ? response.parse : []
  end
end
