require 'http'

# Returns an authenticated user, or nil
class CreateFinalKmap
  def self.call(current_uid:, auth_token:, course_id:, chapter_id:, delete_kmap:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .post("#{ENV['API_HOST']}/kmaps/#{current_uid}/#{course_id}/#{chapter_id}/postkmap",
                         json: {delete_kmap: delete_kmap})
    response.code == 201 ? response.parse : nil
  end
end
