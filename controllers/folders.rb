require 'sinatra'

# Click course and show three folders(concept,subtitle,)
class KeywordCloudApp < Sinatra::Base
  post '/accounts/:uid/:course_id/:folder_type' do
    folders_url = "/accounts/#{@current_uid}/#{params[:course_id]}/#{params[:folder_type]}"
    if @current_uid && @current_uid.to_s == params[:uid]
      @auth_token = session[:auth_token]
      cid = params[:course_id]
      folder_type = params[:folder_type]
      folders_url = "/accounts/#{@current_uid}/#{cid}/#{folder_type}"
      new_folder = CreateFolder.call(uid: @current_uid,
                                     auth_token: @auth_token,
                                     cid: cid,
                                     folder_url: nil,
                                     folder_type: folder_type)


      if new_folder
        redirect "/accounts/#{@current_uid}/#{params[:course_id]}/#{new_folder.first['attributes']['folder_type']}"
      else
        flash[:error] = '無法建立資料夾！'
        redirect "/accounts/#{@current_uid}"
      end
    end
  end

  get '/accounts/:uid/:course_id/:folder_type' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @course_id = params[:course_id]
      @folder_type = params[:folder_type]
      @folder = GetOwnedFolder.call(current_uid: @current_uid,
                                    auth_token: session[:auth_token],
                                    course_id: @course_id,
                                    folder_type: @folder_type)
      @ordered_folder = @folder.sort_by { |chapter| chapter[:chapter_order] }

      slim(:chapter_folder)
    else
      slim(:home)
    end
  end

  get '/accounts/:uid/:course_id/subtitles/:folder_id' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @course_id = params[:course_id]
      @folder_id = params[:folder_id]
      @folder_type = "subtitles"
      @folder = GetFolderContents.call(current_uid: @current_uid,
                                       auth_token: session[:auth_token],
                                       course_id: @course_id,
                                       folder_id: @folder_id)
      if @folder
        @video_info = GetVideoContents.call(current_uid: @current_uid,
                                            auth_token: session[:auth_token],
                                            course_id: @course_id,
                                            folder_id: @folder_id,
                                            folder: @folder)
        slim(:subtitle_folder)
      else
        flash[:error] = '在您的帳號中，我們無法找到資料夾'
        redirect "/accounts/#{params[:uid]}/#{params[:course_id]}/#{params[:folder_type]}"
      end
    else
      redirect '/login'
    end
  end

  get '/accounts/:uid/:course_id/slides/:folder_id' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @course_id = params[:course_id]
      @folder_id = params[:folder_id]
      @folder_type = "slides"
      @folder = GetFolderContents.call(current_uid: @current_uid,
                                       auth_token: session[:auth_token],
                                       course_id: @course_id,
                                       folder_id: @folder_id)
      if @folder
        slim(:slide_folder)
      else
        flash[:error] = '在您的帳號中，我們無法找到資料夾'
        redirect "/accounts/#{params[:uid]}/#{params[:course_id]}/#{params[:folder_type]}"
      end
    else
      redirect '/login'
    end
  end

  get '/accounts/:uid/:course_id/concepts/:folder_id' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @course_id = params[:course_id]
      @folder_id = params[:folder_id]
      @folder_type = "concepts"
      @folder = GetFolderContents.call(current_uid: @current_uid,
                                       auth_token: session[:auth_token],
                                       course_id: @course_id,
                                       folder_id: @folder_id)
      if @folder
        slim(:concept_folder)
      else
        flash[:error] = '在您的帳號中，我們無法找到資料夾'
        redirect "/accounts/#{params[:uid]}/#{params[:course_id]}/#{params[:folder_type]}"
      end
    else
      redirect '/login'
    end
  end
end
