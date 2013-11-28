namespace :test do

  Rake::TestTask.new(:lib) do |t|
    t.libs << "lib"
    t.libs << "test"
    t.pattern = "test/lib/**/*_test.rb"
  end

end

Rake::Task[:test].enhance { Rake::Task["test:lib"].invoke }
