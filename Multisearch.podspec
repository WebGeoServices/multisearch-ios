Pod::Spec.new do |s|
  s.name = 'Multisearch'
  s.version = '1.0.2'
  s.license = 'MIT'
  s.summary = 'Multisearch'
  s.homepage = 'https://github.com/WebGeoServices/multisearch-ios'
  s.authors = { 'Web Geo Services' => 'https://developers.woosmap.com/support/contact/'}
  s.source = { :git => 'https://github.com/WebGeoServices/multisearch-ios.git', :tag => s.version }
  s.documentation_url = 'https://github.com/WebGeoServices/multisearch-ios'

  s.ios.deployment_target = '11.0'

  s.swift_versions = ['5.1', '5.2']
  s.source_files = 'Multisearch/*.swift', 'Multisearch/FuseJS/*.swift',Multisearch/Network/*.swift,Multisearch/Network/*.swift,
 
end


48,8385379
2,3785842