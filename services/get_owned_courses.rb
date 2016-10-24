require 'http'

class GetOwnedCourses
  def self.call(current_uid:, auth_token:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .get("#{ENV['API_HOST']}/accounts/#{current_uid}")
    puts 'Response from server'
    response.code == 200 ? extract_courses(response.parse) : []
  end

  private

  def self.extract_courses(courses)
    courses['data'].map do |course|
      { cid: course['cid'],
        coures_name: course['name']}
    end
  end
end
