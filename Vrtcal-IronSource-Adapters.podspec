Pod::Spec.new do |s|
    s.name         = "Vrtcal-IronSource-Adapters"
    s.version      = "1.0.2"
    s.summary      = "Allows mediation with Vrtcal as either the primary or secondary SDK"
    s.homepage     = "http://vrtcal.com"
    s.license = { :type => 'Copyright', :text => <<-LICENSE
                   Copyright 2020 Vrtcal Markets, Inc.
                  LICENSE
                }
    s.author       = { "Scott McCoy" => "scott.mccoy@vrtcal.com" }
    
    s.source       = { :git => "https://github.com/vrtcalsdkdev/Vrtcal-IronSource-Adapters.git", :tag => "#{s.version}" }
    s.source_files = "*.{h,m}"

    s.platform = :ios
    s.ios.deployment_target  = '10.0'

    s.dependency 'IronSourceSDK', '~> 7.1'
    s.dependency 'VrtcalSDK'

    s.static_framework = true
end
