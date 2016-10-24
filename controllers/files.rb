require 'sinatra'

# Click course and show three folders(concept,subtitle,slide)
class KeywordCloudApp < Sinatra::Base
  post '/accounts/:uid/:course_id/:folder_type/:folder_id/files/' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @auth_token = session[:auth_token]
      @cid = params[:course_id]
      @folder_type = params[:folder_type]
      folder_url = "/accounts/#{@current_uid}/#{@cid}/#{@folder_type}/#{params[:folder_id]}"
      begin
        new_file = CreateFile.call(
          current_uid: @current_uid,
          auth_token: session[:auth_token],
          course_id: params[:course_id],
          folder_id: params[:folder_id],
          filename: params['fileToUpload'][:filename],
          description: params['fileToUpload'][:type],
          document: params['fileToUpload'][:tempfile])

        flash[:notice] = '這是您的新文件！'
        redirect folder_url
      rescue => e
        flash[:error] = 'Something went wrong -- we will look into it!'
        logger.error "NEW FILE FAIL: #{e}"
        redirect folder_url
      end
    end
  end

  post '/accounts/:uid/:course_id/:folder_type/:folder_id/:video_id/files/' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @auth_token = session[:auth_token]
      @cid = params[:course_id]
      @folder_type = params[:folder_type]
      folder_url = "/accounts/#{@current_uid}/#{@cid}/#{@folder_type}/#{params[:folder_id]}"
      begin
        new_file = CreateSubtitle.call(
          current_uid: @current_uid,
          auth_token: session[:auth_token],
          course_id: params[:course_id],
          folder_id: params[:folder_id],
          video_id: params[:video_id],
          filename: params['fileToUpload'][:filename],
          description: params['fileToUpload'][:type],
          document: params['fileToUpload'][:tempfile])

        flash[:notice] = '這是您的新文件！'
        redirect folder_url
      rescue => e
        flash[:error] = 'Something went wrong -- we will look into it!'
        logger.error "NEW FILE FAIL: #{e}"
        redirect folder_url
      end
    end
  end

  post '/accounts/:uid/:course_id/:folder_type/:folder_id/input/' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @auth_token = session[:auth_token]
      @cid = params[:course_id]
      @folder_type = params[:folder_type]
      folder_url = "/accounts/#{@current_uid}/#{@cid}/#{@folder_type}/#{params[:folder_id]}"
      begin
         new_file = CreateFile.call(
           current_uid: @current_uid,
           auth_token: session[:auth_token],
           course_id: params[:course_id],
           folder_id: params[:folder_id],
           filename: params[:folder_id]+".txt",
           description: 'text/handwrite',
           document: params[:confirmationText],
           )

        flash[:notice] = '這是您的新文件！'
        redirect folder_url
      rescue => e
        flash[:error] = 'Something went wrong -- we will look into it!'
        logger.error "NEW FILE FAIL: #{e}"
        redirect folder_url
      end
    end
  end

  get '/accounts/:uid/:course_id/:folder_type/:folder_id/files/' do
    @cid = params[:course_id]
    @folder_type = params[:folder_type]
    folder_url = "/accounts/#{@current_uid}/#{@cid}/#{@folder_type}/#{params[:folder_id]}"
    redirect folder_url
  end

  get '/accounts/:uid/:course_id/:folder_type/:folder_id/files/:file_id' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @auth_token = session[:auth_token]
      @cid = params[:course_id]
      @folder_type = params[:folder_type]
      @file_id = params[:file_id]
      begin
        @folder_url = "/accounts/#{@current_uid}/#{@cid}/#{@folder_type}/#{params[:folder_id]}"
        filename, temp_file = GetFileDetails.call(
          current_uid: @current_uid,
          auth_token: @auth_token,
          course_id: @cid,
          folder_id: params[:folder_id],
          file_id: @file_id)
        send_file(temp_file.path, :filename => filename, :disposition => 'attachment')
        # puts "FILE FOUND: #{temp_file}"
        temp_file.unlink
      rescue => e
        logger.error "GET FILE FAILED: #{e}"
        flash[:error] = "Could not get that file"
        redirect @folder_url
      end
    end
  end

  get '/accounts/:uid/:course_id/:folder_type/:folder_id/:video_id/files/:file_id' do
    if @current_uid && @current_uid.to_s == params[:uid]
      @auth_token = session[:auth_token]
      @cid = params[:course_id]
      @folder_type = params[:folder_type]
      @file_id = params[:file_id]
      begin
        @folder_url = "/accounts/#{@current_uid}/#{@cid}/#{@folder_type}/#{params[:folder_id]}"
        filename, temp_file = GetSubtitleDetails.call(
          current_uid: @current_uid,
          auth_token: @auth_token,
          course_id: @cid,
          folder_id: params[:folder_id],
          video_id: params[:video_id],
          file_id: @file_id)
        send_file(temp_file.path, :filename => filename, :disposition => 'attachment')
        # puts "FILE FOUND: #{temp_file}"
        temp_file.unlink
      rescue => e
        logger.error "GET FILE FAILED: #{e}"
        flash[:error] = "Could not get that file"
        redirect @folder_url
      end
    end
  end

  post '/accounts/:uid/:course_id/:folder_type/:folder_id/files/delete' do
    if @current_uid && @current_uid.to_s == params[:uid]

      @auth_token = session[:auth_token]
      @cid = params[:course_id]
      @folder_type = params[:folder_type]
      folder_url = "/accounts/#{@current_uid}/#{@cid}/#{@folder_type}/#{params[:folder_id]}"
      begin
         delete_file = DeleteFile.call(
            current_uid: @current_uid,
            auth_token: session[:auth_token],
            course_id: params[:course_id],
            folder_id: params[:folder_id],
            filename: params[:filename]
            )
        redirect folder_url
      rescue => e
        flash[:error] = 'Something went wrong -- we will look into it!'
        logger.error "NEW FILE FAIL: #{e}"
        redirect folder_url
      end
    end
  end

  post '/accounts/:uid/:course_id/:folder_type/:folder_id/:video_id/files/delete' do
    if @current_uid && @current_uid.to_s == params[:uid]

      @auth_token = session[:auth_token]
      @cid = params[:course_id]
      @folder_type = params[:folder_type]
      folder_url = "/accounts/#{@current_uid}/#{@cid}/#{@folder_type}/#{params[:folder_id]}"
      begin
         delete_file = DeleteSubtitle.call(
            current_uid: @current_uid,
            auth_token: session[:auth_token],
            course_id: params[:course_id],
            folder_id: params[:folder_id],
            video_id: params[:video_id],
            filename: params[:filename]
            )
        redirect folder_url
      rescue => e
        flash[:error] = 'Something went wrong -- we will look into it!'
        logger.error "NEW FILE FAIL: #{e}"
        redirect folder_url
      end
    end
  end
end
