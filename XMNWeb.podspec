#
# Be sure to run `pod lib lint XMNWeb.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'XMNWeb'
  s.version          = '0.2.5'
  s.summary          = 'XMNWeb provide WKWebView And JS connection'

  s.homepage         = 'https://github.com/ws00801526/XMNWeb'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ws00801526' => '3057600441@qq.com' }
  s.source           = { :git => 'https://github.com/ws00801526/XMNWeb.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'
  s.frameworks = 'UIKit', 'WebKit'
  s.default_subspec = 'Bridge'


  s.subspec 'Core' do |sp|
  	sp.source_files = 'XMNWeb/Classes/Core/**/*'
	  sp.public_header_files = 'XMNWeb/Classes/Core/*.h'
    sp.dependency 'KVOController'
  end

 s.subspec 'Bridge' do |sp|
    sp.source_files = 'XMNWeb/Classes/Bridge/**/*'
	  sp.public_header_files = 'XMNWeb/Classes/Bridge/*.h'
	  sp.resource_bundles = {
      'XMNWebBridge' => ['XMNWeb/Assets/Bridge/**/*']
	}
	  sp.dependency 'XMNWeb/Core'
    sp.pod_target_xcconfig = {'GCC_PREPROCESSOR_DEFINITIONS' => 'XMNBRIDGE_ENABLED=1'}
    sp.user_target_xcconfig = {'GCC_PREPROCESSOR_DEFINITIONS' => 'XMNBRIDGE_ENABLED=1'}
  end
end
