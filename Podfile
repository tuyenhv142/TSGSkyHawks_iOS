platform :ios, '15.6'
project 'EagleBaseballTeam.xcodeproj'

target 'EagleBaseballTeam' do
  use_frameworks!

  # Pods for EagleBaseballTeam
  pod 'Masonry'
  pod 'SDWebImage'
  pod 'AFNetworking'
  pod 'MBProgressHUD'
  pod 'IQKeyboardManager'
  pod 'MJRefresh'
  pod 'MJExtension'
  pod 'ZXingObjC'
  pod 'YYModel'
  pod 'Firebase/Messaging', :modular_headers => true
  pod 'GoogleAPIClientForREST/YouTube', '~> 1.2.1'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.6'
    end
  end
end
