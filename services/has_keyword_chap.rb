require 'http'

class HasKeywordChap
  def self.call(current_uid:, auth_token:, course_id:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/keywords/#{current_uid}/#{course_id}")
    response.code == 200 ? response.parse : []
  end
end
