require_relative 'lib/svg_analyzer/version'

Gem::Specification.new do |spec|
  spec.name = 'svg_analyzer'
  spec.version = SvgAnalyzer::VERSION
  spec.authors = ['calebanderson']
  spec.email = ['caleb.r.anderson.1@gmail.com']
  spec.homepage = 'https://github.com/calebanderson/svg_analyzer'
  spec.summary = 'Helpers for SVG string parsing and converting'
  spec.description = 'Helpers for SVG string parsing and converting'
  spec.license = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata['allowed_push_host'] = 'TODO: Set to http://mygemserver.com'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/calebanderson/svg_analyzer'
  spec.metadata['changelog_uri'] = 'https://github.com/calebanderson/svg_analyzer/blob/master/CHANGELOG.md'

  spec.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']

  spec.add_dependency 'rails', '>= 4.2'
  spec.add_dependency 'shared_helpers'
end
