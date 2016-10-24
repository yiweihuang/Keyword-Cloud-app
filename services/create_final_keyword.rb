require 'http'

# Returns an authenticated user, or nil
class CreateFinalKeyword
  def self.call(current_uid:, auth_token:, course_id:, chapter_id:, delete_keyword:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .post("#{ENV['API_HOST']}/accounts/#{current_uid}/#{course_id}/#{chapter_id}/postkeyword",
                         json: {delete_keyword: delete_keyword})
    response.code == 201 ? response.parse : nil
  end
end
