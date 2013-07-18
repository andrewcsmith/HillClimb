require 'rdoc/task'

task :test do
  Dir.glob("test/*_test.rb") do |file|
    ruby file
  end
end

RDoc::Task.new do |rdoc|
    rdoc.main = 'README.md'
    files = ['README.md', 'lib/*']
    rdoc.rdoc_files.include('README.md', 'lib/*')
    rdoc.rdoc_dir = 'doc'
    rdoc.options << '--all'
end
