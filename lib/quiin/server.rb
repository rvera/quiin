require 'sinatra'
require 'data_mapper'
require 'dm-migrations'
require 'haml'
require 'sass'
require 'will_paginate'
require 'will_paginate/data_mapper'
 
dir = File.dirname(File.expand_path(__FILE__))
set :views,     "#{dir}/server/views"
set :public_folder, "#{dir}/server/public"

#DataMapper.setup(:default, 'sqlite::memory:')
DataMapper.setup(:default, 'sqlite:///tmp/project.db')
class QuiinRun
  include DataMapper::Resource
  property :id,           Serial
  property :name,         Text
  property :command,      Text,     :required => true
  property :exit_code,    String,   :required => true
  property :runtime,      Integer,  :required => true
  property :executed_at,  DateTime, :required => true
  property :created_at,   DateTime
  property :stdout,       Text
  property :stderr,       Text

  before :save do |quiin_run|
    quiin_run.name = quiin_run.command if quiin_run.name.nil? || quiin_run.name.strip == ""
  end
end
QuiinRun.raise_on_save_failure = true
#DataMapper.auto_migrate!
DataMapper.auto_upgrade!

get '/stylesheets/application.css' do
 content_type 'text/css', :charset => 'utf-8'
 scss :"stylesheets/application", :style => :expanded
end

post '/' do
  begin
    QuiinRun.create(params).to_json
  rescue
    false.to_json
  end
end

get '/' do
  runs = QuiinRun.all(:order => [:created_at.desc]).paginate(:page => params[:page], :per_page => 20)
  haml :index, :locals => {:runs => runs }
end

get '/show/:id' do
  run = QuiinRun.get params[:id]
  haml :show, :locals => { :run => run}
end