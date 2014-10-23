require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'

task :default do
  sh %{rake -T}
end

desc "Run syntax, lint and spec tasks."
task :test => [:syntax, :lint, :spec]

desc "Run syntax, lint and spec_standalone tasks."
task :test_standalone => [:syntax, :lint, :spec_standalone]

exclude_paths = [
  "pkg/**/*",
  "vendor/**/*",
  "spec/**/*",
]

Rake::Task[:lint].clear
PuppetLint::RakeTask.new :lint do |config|
  config.ignore_paths = exclude_paths
  config.fail_on_warnings = true
  config.log_format = "%{path}:%{linenumber}:%{check}:%{KIND}:%{message}"
  config.disable_checks = ["80chars", "class_inherits_from_params_class"]
  #config.relative = true
end
PuppetLint.configuration.relative = true

PuppetSyntax.exclude_paths = exclude_paths
