platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

target 'GitHubRepoSearch' do
    pod 'Apollo'
    pod 'PTPopupWebView'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        if target.name == 'PTPopupWebView'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2.3'
            end
        end
    end
end
