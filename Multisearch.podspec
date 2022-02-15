Pod::Spec.new do |s|
  s.name = 'Multisearch'
  s.version = '1.0.2'
  s.license = 'MIT'
  s.summary = 'Multisearch'
  s.homepage = 'https://github.com/Woosmap/multisearch-ios'
  s.authors = { 'Web Geo Services' => 'https://developers.woosmap.com/support/contact/'}
  s.source = { :git => 'https://github.com/Woosmap/multisearch-ios.git', :tag => s.version }
  s.documentation_url = 'https://github.com/Woosmap/multisearch-ios'

  s.ios.deployment_target = '10.0'

  s.swift_versions = ['5.1', '5.2']
  s.source_files = [
  	'Multisearch/*.swift', 
  	'Multisearch/FuseJS/*.swift',
  	'Multisearch/Network/*.swift',
  	'Multisearch/Network/Models/*.swift',
  	'Multisearch/ProviderConfig/*.swift',
  	'Multisearch/Providers/*.swift',
  	]
 
end
