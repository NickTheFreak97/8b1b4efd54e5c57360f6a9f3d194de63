# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'UIKitPlayground' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'SnapKit'
  pod 'SwiftSVG', '~> 2.0'
  pod 'ISVImageScrollView'

  # Pods for UIKitPlayground

  post_install do |installer|
      installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
              end
          end
      end
  end
  
  target 'UIKitPlaygroundTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'UIKitPlaygroundUITests' do
    # Pods for testing
  end

end
