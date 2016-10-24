require 'http'

class GetVideoContents
  def self.call(current_uid:, auth_token:, course_id:, folder_id:, folder:)
    response = HTTP.auth("Bearer #{auth_token}")
                   .post("#{ENV['API_HOST']}/accounts/#{current_uid}/#{course_id}/folders/#{folder_id}/?")
    response.code == 201 ? video_contents(response.parse, folder) : []
  end
  private
  def self.video_contents(content, folder)
    f = folder[:files].map do |info|
      {
        filename: info[:filename],
        file_id: info[:file_id]
      }

    end
    f_video_id = folder[:files].map do |info|
      info[:video_id]
    end

    hash_Array = Array.new()
    content.map.with_index do |info, index|
      hash_Array = { name: info["attributes"]["name"].to_s,
                     video_order: info["attributes"]["video_order"].to_i,
                     video_id: info["attributes"]["video_id"].to_i,
                     filename: nil}
      f_video_id.each.with_index do |id,index|
        if hash_Array[:video_id] == id
          hash_Array[:filename] = f[index][:filename]
          hash_Array[:file_id] = f[index][:file_id]
          break
        end
      end
      hash_Array
    end
  end
end
