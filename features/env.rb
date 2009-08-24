app_file = File.expand_path(File.dirname(__FILE__)+'/../shrtn')
db_file = 'test.sqlite3'
ENV['DATABASE'] = db_file
FileUtils.rm_r(db_file)
require app_file
require 'rack/test'
require 'webrat'

Sinatra::Application.app_file = app_file

Shrtn.set :environment, :development

Webrat.configure do |config|
  config.mode = :rack
end

class MyWorld
  include Rack::Test::Methods
  include Webrat::Methods
  include Webrat::Matchers

  Webrat::Methods.delegate_to_session :response_code, :response_body

  def app
    Shrtn
  end
end

World{MyWorld.new}

Before do
  DB[:urls].delete
end