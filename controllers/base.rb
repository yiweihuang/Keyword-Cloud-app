require 'sinatra'
require 'rack-flash'
# require "rack-timeout"
require 'rack/ssl-enforcer'

# Base class for KeywordCloud Web Application
class KeywordCloudApp < Sinatra::Base
  enable :logging

  use Rack::Session::Cookie, secret: ENV['MSG_KEY'],
                             expire_after: 60 * 60 * 24 * 7
  use Rack::Flash

  configure :production do
    use Rack::SslEnforcer
  end

  set :views, File.expand_path('../../views', __FILE__)
  set :public_folder, File.dirname(__FILE__) + '/../public'

  before do
    if session[:current_uid]
      @current_uid = SecureMessage.decrypt(session[:current_uid])
    end
  end

  get '/' do
    slim :home
  end
end
