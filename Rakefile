require 'rake'

desc "Run shUnit2 tests"
task :test do
  pass = true
  Dir.glob("assets/**/test/*_test.sh").each do |test|
    ["bash", "zsh -y"].each do |shell|
      puts "== Running test with [#{shell}]: #{test}"
      pass = false unless system("#{shell} #{test}")
    end
  end
  exit pass ? 0 : 1
end

task :default => ['test']

