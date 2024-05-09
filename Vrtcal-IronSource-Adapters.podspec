Pod::Spec.new do |s|
    s.name         = "Vrtcal-IronSource-Adapters"
    s.version      = "1.1.1"
    s.summary      = "Allows mediation with Vrtcal as either the primary or secondary SDK"
    s.homepage     = "http://vrtcal.com"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2020 Vrtcal Markets, Inc.
                  LICENSE
                }
    s.author       = { "Scott McCoy" => "scott.mccoy@vrtcal.com" }
    
    s.source       = { :git => "https://github.com/vrtcalsdkdev/Vrtcal-IronSource-Adapters.git", :tag => "#{s.version}" }
    s.source_files = "Source/**/*.swift"

    s.platform = :ios
    s.ios.deployment_target = '11.0'

    s.dependency 'IronSourceSDK', '~> 8.0.0'
    s.dependency 'VrtcalSDK'

    s.pod_target_xcconfig = {
        "VALID_ARCHS": "arm64 arm64e armv7 armv7s x86_64"
    }

    s.static_framework = true
end
