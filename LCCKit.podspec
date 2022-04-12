#
# Be sure to run `pod lib lint CCKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'LCCKit'
  s.version          = '0.0.2'
  s.summary          = 'Tools for iOS development'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'Tools for iOS development base in Object-C.'

  s.homepage         = 'https://github.com/LuCyCue/CCKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lucyfa' => 'lccjust123@163.com' }
  s.source           = { :git => 'https://github.com/LuCyCue/CCKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'CCKit/Classes/**/*'
  # 是否是静态库，如果是静态库，需要设置该选项，默认为动态库
#  s.static_framework = true
  
  s.subspec 'CCNumberScrollView' do |ss|
    ss.source_files = 'CCKit/Classes/CCNumberScrollView/*'
#    ss.dependency 'Masonry'
  end
  
  s.subspec 'CCChart' do |ss|
    ss.source_files = 'CCKit/Classes/CCChart/*'
  end
  
  s.subspec 'CCNavigationController' do |ss|
    ss.source_files = 'CCKit/Classes/CCNavigationController/*'
  end
  
  s.subspec 'CCLetterIndexView' do |ss|
    ss.source_files = 'CCKit/Classes/CCLetterIndexView/*'
  end
  
  s.subspec 'CCSafe' do |ss|
    ss.source_files = 'CCKit/Classes/CCSafe/*'
  end
  
  s.subspec 'CCCategories' do |ss|
    ss.source_files = 'CCKit/Classes/CCCategories/*'
  end
  
  s.subspec 'CCScrollViewNest' do |ss|
    ss.source_files = 'CCKit/Classes/CCScrollViewNest/*'
  end
  
  s.subspec 'CCPageControl' do |ss|
    ss.source_files = 'CCKit/Classes/CCPageControl/*'
  end
  
  s.subspec 'CCFileDownload' do |ss|
    ss.source_files = 'CCKit/Classes/CCFileDownload/*'
  end
  
  s.frameworks = 'UIKit','Photos'
  # s.resource_bundles = {
  #   'CCKit' => ['CCKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.dependency 'AFNetworking', '~> 2.3'
end
