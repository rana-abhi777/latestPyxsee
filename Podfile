# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Share' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'SDWebImage/WebP'
  pod 'EMPageViewController'
  pod 'RxSwift',    '~> 3.0'
  pod 'RxCocoa',    '~> 3.0'
  pod 'Moya/RxSwift'
  pod 'Moya-ModelMapper/RxSwift', '4.0.0-beta.3'
  pod 'RxOptional'
  pod 'IQKeyboardManagerSwift'
  pod 'Instabug'
  pod 'PieCharts'
  pod 'SVProgressHUD'
  # Pods for Share

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = "3.0"
        end
    end
end
