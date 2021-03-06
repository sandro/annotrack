#!/usr/bin/env ruby
#

begin
  require 'rubygems'
rescue LoadError
  # no rubygems to load, so we fail silently
end

require 'trollop'
require 'date'
require File.expand_path(File.join(File.dirname(__FILE__), %w(.. lib annotrack)))

opts = Trollop::options do
  banner <<-EOS
Annotrack will give you a summary of a user's pivotal tracker history for a given and date
Example:
    annotrack --username sandro --project 123

Usage:
    annotrack [options]
where [options] are:
EOS

  opt :username, "User who's activity you want to summarize", :type => String, :required => true
  opt :project, "Narrow user history down to a specific project", :type => Integer, :required => true
  opt :date, "Date you would like tracker to summarize", :default => Date.today.to_s
end

parsed_date = Chronic.parse(opts[:date])
unless parsed_date
  puts "Could not understand the date: #{opts[:date]}"
  exit 1
end

track = Annotrack.new(opts[:username], parsed_date, opts[:project])
track.summary

