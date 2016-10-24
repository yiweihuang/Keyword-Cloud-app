Dir.glob('./{config,lib,services,views,controllers,forms}/init.rb').each do |file|
  require file
end

run KeywordCloudApp
