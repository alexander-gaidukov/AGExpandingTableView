#
# Be sure to run `pod lib lint AGExpandingTableView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'AGExpandingTableView'
  s.version          = '0.1.0'
  s.summary          = 'A subclass on UITableView that provides the ability to expand or collapse cells with different animation.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'This CocoaPod provides the ability to expand or collapse table view cell with different animations. Such as folding or sliding'

  s.homepage         = 'https://github.com/alexander-gaidukov/AGExpandingTableView'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'alexander-gaidukov' => 'alexander.gaidukov@gmail.com' }
  s.source           = { :git => 'https://github.com/alexander-gaidukov/AGExpandingTableView.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'AGExpandingTableView/Classes/**/*'
  
  # s.resource_bundles = {
  #   'AGExpandingTableView' => ['AGExpandingTableView/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
