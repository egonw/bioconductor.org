#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'
require './scripts/PubSubHubbub-master/lib/pubsubhubbub'

unless File.exists?("tmp/rss_urls.txt")
    puts "url file does not exist!"
    exit 1
end

config = YAML.load_file("./config.yaml")
hub_url = config["rss_hub_url"]

lines = File.readlines "tmp/rss_urls.txt"

feeds = lines.map{|i| i.chomp}

EventMachine.run {
  pub = EventMachine::PubSubHubbub.new(hub_url).publish feeds
  pub.callback {
    puts "Successfully notified hub." 
    EventMachine.stop
  }
  pub.errback  { puts "Uh oh, something broke: #{pub.response}" }
}