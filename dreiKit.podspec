Pod::Spec.new do |s|
  s.name             = "dreiKit"
  s.version          = "1.0.7"
  s.summary          = "A short description of dreiKit."
  s.homepage         = "https://github.com/dreipol/dreiKit"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "dreipol GmbH" => "dev@dreipol.ch" }
  s.source           = { git: "https://github.com/dreipol/dreiKit.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/dreipol'
  s.ios.deployment_target = '11.0'
  s.requires_arc = true
  s.ios.source_files = 'Sources/dreiKit/**/*.{swift}'
  s.preserve_path = '.swiftlint.yml'
  s.swift_version = '5.0'
  # s.resource_bundles = {
  #   'dreiKit' => ['dreiKit/Sources/**/*.xib']
  # }
  s.ios.frameworks = 'UIKit', 'Foundation'
  # s.dependency 'Eureka', '~> 4.0'
  s.info_plist = {
    'CFBundleIdentifier' => 'ch.dreipol.dreikit'
  }
  s.pod_target_xcconfig = {
    'PRODUCT_BUNDLE_IDENTIFIER': 'ch.dreipol.dreikit'
  }
  s.script_phases = [
    {
        :name => 'Swiftlint',
        :execution_position => :before_compile,
        :shell_path => '/bin/sh',
        :script => <<-SCRIPT
        cd "$PODS_TARGET_SRCROOT/"
        
        if which swiftlint >/dev/null; then
          swiftlint
        else
          echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
        fi
        SCRIPT
    }
]
end
