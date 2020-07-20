Pod::Spec.new do |s|
  s.name             = "dreiKit"
  s.version          = "0.0.1"
  s.summary          = "A short description of dreiKit."
  s.homepage         = "https://github.com/dreipol/dreiKit"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "dreipol GmbH" => "dev@dreipol.ch" }
  s.source           = { git: "https://github.com/dreipol/dreiKit.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/dreipol'
  s.ios.deployment_target = '12.0'
  s.requires_arc = true
  s.ios.source_files = 'Sources/dreiKit/**/*.{swift}'
  # s.resource_bundles = {
  #   'dreiKit' => ['dreiKit/Sources/**/*.xib']
  # }
  s.ios.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'Eureka', '~> 4.0'
  s.info_plist = {
    'CFBundleIdentifier' => 'ch.dreipol.dreikit'
  }
end
