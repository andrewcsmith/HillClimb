require 'rdoc/task'

task :test do
  ruby 'test/hill_climb_test.rb'
end

RDoc::Task.new do |rdoc|
    rdoc.main = 'README.md'
    files = ['README.md', 'lib/*']
    rdoc.rdoc_files.include('README.md', 'lib/*')
    rdoc.rdoc_dir = 'doc'
    rdoc.options << '--all'
end
