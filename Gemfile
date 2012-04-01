source "http://rubygems.org"

#
# Chef
#

#gem 'chef',            "= 0.10.8"
gem 'chef', :git => "https://github.com/opscode/chef.git"
#gem 'ironfan',         "~> 3.1.4"
gem 'ironfan', :git => "https://github.com/infochimps-labs/ironfan.git"

# vagrant and chef are being dicks about the version net-ssh should have.
# to use the knife vagrant stuff you will have to munge the chef gemspec
gem 'vagrant', '~> 1.0'
#gem 'veewee'

#
# Test drivers
#

group :test do
  gem 'rake'
  gem 'bundler',       "~> 1"
  gem 'rspec',         "~> 2.5"
  gem 'redcarpet',   "~> 2"
  gem 'cucumber',      "~> 1.1"
end

#
# Development
#

group :development do
  gem 'yard',          "~> 0.6"
  gem 'jeweler'

  gem 'ruby_gntp'

  gem 'guard',         "~> 1"
  gem 'guard-process', "~> 1"
  gem 'guard-chef',    :git => 'git@github.com:infochimps-forks/guard-chef.git'
  gem 'guard-cucumber'
end

group :support do
  gem 'pry'  # useful in debugging
  gem 'grit' # used in rake scripts for push/pulling cookbooks
end
