# frozen_string_literal: true

require_relative 'lib/legion/extensions/executive_function/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-executive-function'
  spec.version       = Legion::Extensions::ExecutiveFunction::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'LEX Executive Function'
  spec.description   = 'Miyake & Friedman (2000, 2012) unity/diversity model of executive functions: ' \
                       'inhibition, shifting, and working memory updating'
  spec.homepage      = 'https://github.com/LegionIO/lex-executive-function'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']      = spec.homepage
  spec.metadata['source_code_uri']   = 'https://github.com/LegionIO/lex-executive-function'
  spec.metadata['documentation_uri'] = 'https://github.com/LegionIO/lex-executive-function'
  spec.metadata['changelog_uri']     = 'https://github.com/LegionIO/lex-executive-function'
  spec.metadata['bug_tracker_uri']   = 'https://github.com/LegionIO/lex-executive-function/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir.glob('{lib,spec}/**/*') + %w[lex-executive-function.gemspec Gemfile]
  end
  spec.require_paths = ['lib']
  spec.add_development_dependency 'legion-gaia'
end
