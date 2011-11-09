require 'dm-migrations'
require 'data_mapper'

module Quiin

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

    def shortname
      name.length > 60 ? "#{name[0..55]} ..." : name
    end

  end
  QuiinRun.raise_on_save_failure = true

end