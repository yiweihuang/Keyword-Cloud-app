require 'sinatra'

# Click course and show three folders(concept,subtitle,slide)
class KeywordCloudApp < Sinatra::Base
  get '/accounts/:uid/:course_id' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @auth_token = session[:auth_token]
      @cid = params[:course_id]
      @course = GetCourseContents.call(current_uid: @current_uid,
                                       auth_token: @auth_token,
                                       course_id: params[:course_id])

      slim(:folder_type)
    else
      slim(:login)
    end
  end
end
