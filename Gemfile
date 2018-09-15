source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in civic_duty.gemspec
gemspec

unless ENV['TRAVIS']
  gem 'pry-byebug'
  require 'pry'
end
