require 'http'

class GetTfidf
  def self.call(current_uid:, auth_token:, course_id:, chapter_id:, number:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/kmaps/#{current_uid}/#{course_id}/#{chapter_id}/#{number}/show")
    response.code == 200 ? response.parse : []
  end
end
