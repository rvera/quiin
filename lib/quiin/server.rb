require 'sinatra/base'
require 'haml'
require 'sass'
require 'will_paginate'
require 'will_paginate/data_mapper'
require 'dm-migrations'
require 'data_mapper'
require 'quiin/config'
require 'quiin/quiin_run'
require 'quiin/helpers'
     
module Quiin

  class Server < Sinatra::Base
    config

    get '/stylesheets/application.css' do
     content_type 'text/css', :charset => 'utf-8'
     scss :"stylesheets/application", :style => :expanded
    end

    post '/' do
      begin
        QuiinRun.create(params).to_json
      rescue
        halt 400, "Bad request! Unable to create object with specified params"
      end
    end

    get '/' do
      runs = QuiinRun.all(:order => [:created_at.desc]).paginate(:page => params[:page], :per_page => 20)
      haml :index, :locals => {:runs => runs }
    end

    get '/:id' do
      run = QuiinRun.get params[:id]
      haml :show, :locals => { :run => run}
    end

  end

end