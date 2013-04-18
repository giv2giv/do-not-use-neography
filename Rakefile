require 'rake'

task :default => [:test]

task :test do
  ruby "test/charity_import_test.rb"
end

namespace :server do
    desc "start server"
    task :start do
        system "shotgun -p9393"
    end
end
