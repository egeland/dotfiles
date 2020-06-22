#!/usr/bin/env ruby

require 'json'
require 'httparty'

team = ARGV[0] || raise('Must specify organization name')

endpoint = "https://api.bitbucket.org/2.0/repositories/#{team}"
auth = {
  username: "USER HERE",
  password: "SECRET HERE"
}

array = Array.new
while true do
  response = HTTParty.get(endpoint,
               basic_auth: auth,
               format: :plain)
  data = JSON.parse(response, symbolize_names: true)
  array.concat(data[:values])
  break if not data[:next]
  endpoint = data[:next]
end

array.each do | repo |
  classifier = repo[:slug].split('-').first
  system("mkdir -p #{classifier}")
  system("#{repo[:scm]} clone git@bitbucket.org:#{team}/#{repo[:slug]} #{classifier}/#{repo[:slug]}")
end

