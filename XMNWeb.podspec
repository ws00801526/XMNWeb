#
# Be sure to run `pod lib lint XMNWeb.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XMNWeb'
  s.version          = '0.1.0'
  s.summary          = 'A short description of XMNWeb.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ws00801526/XMNWeb'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ws00801526' => '3057600441@qq.com' }
  s.source           = { :git => 'https://github.com/ws00801526/XMNWeb.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.default_subspecs = 'Bridge' 
  s.frameworks = 'UIKit', 'WebKit'

  s.source_files = 'XMNWeb/Classes/Core/**/*'
  s.public_header_files = 'XMNWeb/Classes/Core/*.h'

  s.subspec 'Bridge' do |sp|
  	sp.source_files = 'XMNWeb/Classes/Bridge/**/*'
	sp.public_header_files = 'XMNWeb/Classes/Bridge/*.h'
	sp.resource_bundles = {
    'XMNWebBridge' => ['XMNWeb/Assets/Bridge/**/*']
	}

	sp.user_target_xcconfig = {'XMNBRIDGE_ENABLED' => 'YES'}
	sp.pod_target_xcconfig = {'XMNBRIDGE_ENABLED' => 'YES'}
  end
end
