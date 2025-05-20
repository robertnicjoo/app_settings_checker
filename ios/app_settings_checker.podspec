#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint app_settings_checker.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'app_settings_checker'
  s.version          = '1.0.2'
  s.summary          = 'A Flutter plugin for check permissions and opening settings from an app.'
  s.description      = <<-DESC
A Flutter plugin for check permissions and opening settings from an app. By PT. Nicxon International Solutions
                       DESC
  s.homepage         = 'https://github.com/robertnicjoo/app_settings_checker'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'PT. Nicxon International Solutions' => 'dev@nicxonsolutions.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'app_settings_checker_privacy' => ['Resources/PrivacyInfo.xcprivacy']}
end
