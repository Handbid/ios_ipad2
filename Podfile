# Uncomment this line to define a global platform for your project

source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '17.0'
#use_frameworks!

def available_pods
pod 'SwiftFormat/CLI', '~> 0.54.0'
end

target 'Handbid_iPad' do
platform :ios, '17.0'

    available_pods
end

post_install do |pi|
    pi.pods_project.targets.each do |t|
        t.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '17.0'
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
        end
    end
end
