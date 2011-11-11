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
      exit_code      = exit_code.to_s.strip
      stderr         = stderr.to_s.strip.empty? ? nil : stderr.to_s.strip
      true
    end

    def self.problematic_runs_since(datetime)
      (error_runs_since(datetime) | warning_runs_since(datetime)).all(:order => [:executed_at.desc], :executed_at.gt => datetime)
    end

    def self.error_runs_since(since)
      all( :exit_code.not => "0", :executed_at.gt => since ).all(:order => [:executed_at.desc], :executed_at.gt => since)
    end

    def self.warning_runs_since(since)
      all( :exit_code => "0", :stderr.not => "", :executed_at.gt => since ).all(:order => [:executed_at.desc], :executed_at.gt => since)
    end

    def shortname
      name.length > 60 ? "#{name[0..55]} ..." : name
    end

    def success?
      exit_code.strip == "0" && stderr.to_s.strip.empty?
    end

    def warning?
      exit_code.strip == "0" && !stderr.to_s.strip.empty?
    end

    def error?
      exit_code.strip != "0"
    end

  end
  QuiinRun.raise_on_save_failure = true

end