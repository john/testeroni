# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Testeroni::Application.initialize!

Haml::Template.options[:format] = :html5
# Not relevant, because no tags autoclose in html5 mode
# Haml::Template.options[:autoclose] = ['meta', 'img', 'link', 'br', 'hr', 'input', 'area', 'param', 'col', 'base']
