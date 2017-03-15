require 'sinatra'
require 'json'

# Click course and show three folders(concept,subtitle,slide)
class KeywordCloudApp < Sinatra::Base
  get '/kmap/:uid/:course_id/chapter' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @course_id = params[:course_id]
      @folder = GetOwnedFolder.call(current_uid: @current_uid,
                                    auth_token: session[:auth_token],
                                    course_id: @course_id,
                                    folder_type: 'slides')

      @kmap = GetCourseContents.call(current_uid: @current_uid,
                                     auth_token: session[:auth_token],
                                     course_id: params[:course_id])

      @kmap_chid = HasKmapChap.call(current_uid: @current_uid,
                                    auth_token: session[:auth_token],
                                    course_id: @course_id)
      @ordered_folder = @folder.sort_by { |chapter| chapter[:chapter_order] }
      slim(:show_kmaps)
    else
      slim(:home)
    end
  end

  get '/kmap/:uid/:course_id/makekmap' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @auth_token = session[:auth_token]
      @course_id = params[:course_id]
      @chapter_id = params[:chapter_id]
      kmap_url = "/kmap/#{@current_uid}/#{@course_id}/chapter"
      @folder = GetOwnedFolder.call(current_uid: @current_uid,
                                    auth_token: session[:auth_token],
                                    course_id: @course_id,
                                    folder_type: 'slides')

      @kmap = MakeKmap.call(current_uid: @current_uid,
                            auth_token: @auth_token,
                            course_id: @course_id)

      @ordered_folder = @folder.sort_by{ |chapter| chapter[:chapter_order] }
      redirect kmap_url
    else
      slim(:home)
    end
  end

  get '/kmap/:uid/:course_id/:chapter_id/:number/show' do
    content_type 'application/json'
    begin
      if @current_uid && @current_uid.to_s == params[:uid]
        @auth_token = session[:auth_token]
        @course_id = params[:course_id]
        @chapter_id = params[:chapter_id]
        @number = params[:number]
        # @folder = GetOwnedFolder.call(current_uid: @current_uid,
        #                               auth_token: session[:auth_token],
        #                               course_id: @course_id,
        #                               folder_type: 'slides')

        @kmap = GetTfidf.call(current_uid: @current_uid,
                              auth_token: @auth_token,
                              course_id: @course_id,
                              chapter_id: @chapter_id,
                              number: @number)

        JSON.pretty_generate(course_id: @course_id,
                             chapter_id: @chapter_id,
                             kmap: @kmap)
      end
    rescue => e
      logger.info "FAILED to show keyword: #{e.inspect}"
      halt 404
    end
  end
  post '/kmap/:uid/:course_id/chapter/:chapter_id/postkmap' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @auth_token = session[:auth_token]
      @cid = params[:course_id]
      @chid = params[:chapter_id]
      delete_kmap_arr = JSON.parse(request.body.read)
      CreateFinalKmap.call(current_uid: @current_uid,
                           auth_token: @auth_token,
                           course_id: @cid,
                           chapter_id: @chid,
                           delete_kmap: delete_kmap_arr)
    else
      slim(:login)
    end
  end
end
