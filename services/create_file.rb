require 'http'
require 'base64'
require 'pdf/reader'

class CreateFile
  def self.call(current_uid:, auth_token:, course_id:, folder_id:, filename:, description:, document:)
    if description == 'application/pdf'
      origin_data = document.read
      data = String.new
      PDF::Reader.open(document) do |reader|
        pageno = 0
        txt = reader.pages.map do |page|
            pageno += 1
            begin
              page.text
            rescue
              puts "Page #{pageno}/#{reader.page_count} Failed to convert"
            end
        end
        txt.each do |text|
          text = text.to_s
          data += text
        end
      end
    elsif description == 'text/plain'
      origin_data = document.read
      data = origin_data
    elsif description == 'text/handwrite'
      origin_data = document
      data = document
    end

    base64_encode_document = Base64.strict_encode64(data)
    base64_encode_origin_document = Base64.strict_encode64(origin_data)

    response = HTTP.auth("Bearer #{auth_token}")
                   .post("#{ENV['API_HOST']}/accounts/#{current_uid}/#{course_id}/folders/#{folder_id}/files/",
                         json: {filename: filename, document: base64_encode_document, origin_document: base64_encode_origin_document})
    response.code == 201 ? response.parse : nil
  end
end
