require 'rubygems'
require 'bundler'
Bundler.require

desc "Build js app"
task :'js:build' do
  `cd JavaScriptApp && linner build`
end

task :default => :'js:build'