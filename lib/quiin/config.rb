module Quiin
  class Server < Sinatra::Base
    def self.config
      # HTTP BASIC CONF
      # use Rack::Auth::Basic do |username, password|
      #  username == 'admin' && password == 'secret'
      # end
      
      DataMapper.setup(:default, "sqlite://#{Dir.pwd}/project.db") #DataMapper.setup(:default, 'sqlite::memory:')
      DataMapper.auto_upgrade! #DataMapper.auto_migrate!

      register WillPaginate::Sinatra

      dir = File.dirname(File.expand_path(__FILE__))
      set :views,         "#{dir}/server/views"
      set :public_folder, "#{dir}/server/public"

    end
  end
end