%w(sequel sinatra/base uri haml).each  { |lib| require lib}

DB = Sequel.sqlite(ENV['DATABASE']||'shrtn.sqlite3')
DB.create_table? :urls do
  String :key, :null => false, :auto_increment => false
  String :url, :unique => true, :null => false
  Time :created_at

  primary_key :key
  index :key, :unique => true
end

class Shrtn < Sinatra::Base
  use_in_file_templates!
  set :haml, {:format => :html5 }

  get '/' do
    haml :index
  end

  post '/' do
    uri = URI::parse(params[:u])
    raise URI::InvalidURIError unless [URI::HTTP, URI::HTTPS].any? {|k| k === uri}
    @url = Url.shorten!(uri.to_s)
    haml :show
  end

  get '/:u' do
    redirect Url[:key => params[:u]].url
  end

  helpers do
    def url_for(url)
      "http://#{env['HTTP_HOST'] || env['SERVER_NAME']}/#{url.key}"
    end
  end
end

class Url < Sequel::Model
  VALUES = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a

  # ie, find or create by url
  def self.shorten!(u)
    Url[:url => u] ||
    Url.create(:key => next_key, :url => u, :created_at => Time.now)
  end

  # Base(62)
  def self.next_key
    s = ''
    i = DB[:urls].count + 1
    while i > 0
      s << VALUES[i % VALUES.length]
      i /= VALUES.length
    end
    s.reverse
  end
end

__END__

@@ layout
!!!
%html
  %head
    %title shrtn
  = yield

@@ index
%form{:method => 'post'}
  %input{:type => 'text', :name => 'u'}
  %input{:type => 'submit', :value => 'shrtn'}

@@ show
= url_for(@url)
