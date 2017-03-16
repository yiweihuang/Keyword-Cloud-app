require 'http'

# Returns an authenticated user, or nil
class CreateKmapPict
  def self.call(current_uid:, auth_token:, course_id:, chapter_id:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/kmaps/#{current_uid}/#{course_id}/#{chapter_id}/show/kmap")
    response.code == 200 ? response.parse : []
  end
end
