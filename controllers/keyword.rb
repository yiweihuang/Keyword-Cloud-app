require 'sinatra'
require 'json'

# Click course and show three folders(concept,subtitle,slide)
class KeywordCloudApp < Sinatra::Base
  get '/keyword/:uid/:course_id/chapter' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @course_id = params[:course_id]
      @folder = GetOwnedFolder.call(current_uid: @current_uid,
                                    auth_token: session[:auth_token],
                                    course_id: @course_id,
                                    folder_type: 'slides')

      @keyword = GetCourseContents.call(current_uid: @current_uid,
                                        auth_token: session[:auth_token],
                                        course_id: params[:course_id])

      @keyword_chid = HasKeywordChap.call(current_uid: @current_uid,
                                          auth_token: session[:auth_token],
                                          course_id: @course_id)
      @ordered_folder = @folder.sort_by { |chapter| chapter[:chapter_order] }
      slim(:show_keywords)
    else
      slim(:home)
    end
  end

  get '/keyword/:uid/:course_id/chapter/:chapter_id/makekeyword' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @auth_token = session[:auth_token]
      @course_id = params[:course_id]
      @chapter_id = params[:chapter_id]
      keyword_url = "/keyword/#{@current_uid}/#{@course_id}/chapter"
      @folder = GetOwnedFolder.call(current_uid: @current_uid,
                                    auth_token: session[:auth_token],
                                    course_id: @course_id,
                                    folder_type: 'slides')

      @keyword = MakeKeyword.call(current_uid: @current_uid,
                                  auth_token: @auth_token,
                                  course_id: @course_id,
                                  chapter_id: @chapter_id)

      @keyword_chid = HasKeywordChap.call(current_uid: @current_uid,
                                          auth_token: session[:auth_token],
                                          course_id: @course_id)
      @ordered_folder = @folder.sort_by{ |chapter| chapter[:chapter_order] }
      # slim(:show_keywords)
      redirect keyword_url
    else
      slim(:home)
    end
  end
  
  post '/keyword/:uid/:course_id/chapter/:chapter_id/postkeyword/' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @auth_token = session[:auth_token]
      @cid = params[:course_id]
      @chid = params[:chapter_id]
      delete_keyword_arr = JSON.parse(request.body.read)
      CreateFinalKeyword.call(current_uid: @current_uid,
                              auth_token: @auth_token,
                              course_id: @cid,
                              chapter_id: @chid,
                              delete_keyword: delete_keyword_arr)
    else
      slim(:login)
    end
  end
end
