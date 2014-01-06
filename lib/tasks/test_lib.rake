namespace :test do

  Rake::TestTask.new(:lib) do |t|
    t.libs << "lib"
    t.libs << "test"
    t.pattern = "test/lib/**/*_test.rb"
  end

  Rake::TestTask.new(:services) do |t|
    t.libs << "test"
    t.pattern = "test/services/**/*_test.rb"
  end

end

Rake::Task[:test].enhance { Rake::Task["test:lib"].invoke }
Rake::Task[:test].enhance { Rake::Task["test:services"].invoke }
