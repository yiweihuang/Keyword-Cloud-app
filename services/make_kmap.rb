require 'http'

class MakeKmap
  def self.call(current_uid:, auth_token:, course_id:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/kmaps/#{current_uid}/#{course_id}/makekmap")
    response.code == 200 ? response.parse : []
  end
end
