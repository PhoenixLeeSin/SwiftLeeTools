#
# Be sure to run `pod lib lint SwiftLeeTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SwiftLeeTools'
  s.version          = '0.1.3'
  s.summary          = 'A short description of SwiftLeeTools.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
"iOS swift开发通用工具 包括UIKit foundation 网络封装 等"
                       DESC

  s.homepage         = 'https://github.com/350541732/SwiftLeeTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'LeeSin' => '350541732@qq.com' }
  s.source           = { :git => 'https://github.com/350541732/SwiftLeeTools.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SwiftLeeTools/Classes/**/*'
  
   s.resource_bundles = {
     'SwiftLeeTools' => ['SwiftLeeTools/Assets/*.png']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'Alamofire', '~> 4.7' #网络请求
  s.dependency 'SwiftyJSON', '~> 4.0' #Json数据处理
  s.dependency 'QorumLogs'
  s.dependency 'SnapKit', '~> 4.0.0' #自动布局'
  # s.dependency 'Hero'
  s.dependency 'IQKeyboardManagerSwift'
  s.dependency 'AlamofireImage'
  #  s.dependency 'SDWebImage'
  #  s.dependency 'DKCamera'
  #  s.dependency 'DKPhotoGallery' #照片选取(包含SDWebImage)
  #  s.dependency 'DKImagePickerController', '<= 4.1.4' #照片选取
  s.dependency 'DeviceKit'               #设备信息
  s.dependency 'ImageSlideshow/Alamofire'
  s.dependency 'MJRefresh' #上拉刷新 下拉加载
  s.dependency 'SwiftDate', '~> 5.1.0'  #时间工具
  s.dependency 'JXSegmentedView' #切换滚动式图 https://github.com/pujiaxin33/JXSegmentedView
end
