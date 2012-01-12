# Load the rails application
require File.expand_path('../application', __FILE__)

require 'yaml'

# Initialize the rails application
Mathgist::Application.initialize!

APP_CONFIG = YAML::load(File.open("#{Rails.root}/config/application.yml"))
