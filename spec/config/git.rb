RSpec.configure do |config|
  config.before(:each, :git => true) do
    FileUtils.remove_dir(GitDirectory, true) rescue nil
    FileUtils.mkdir_p(GitDirectory)
  end

  config.after(:each, :git => true) do
    FileUtils.remove_dir(GitDirectory, true)
  end
end
