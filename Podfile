# Uncomment this line to define a global platform for your project

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '17.0'
#use_frameworks!

def available_pods

pod 'Arrow', '~> 5.1.1'
pod 'KeychainAccess'
pod 'ProgressIndicatorView', '~> 1.0.0'
pod 'SwiftFormat/CLI'
pod "RecaptchaEnterprise", "18.5.0-beta02"

end

target 'Handbid_iPad' do
platform :ios, '17.0'
    use_frameworks!
  
    available_pods
end


target 'Handbid_iPadUITests' do
    platform :ios, '17.0'
    available_pods
end


post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
        end
    end
end
