
Pod::Spec.new do |s|

  s.name         = "RRRTipsHUD"
  s.version      = "1.0.0"
  s.summary      = "HUD"
  s.description  = <<-DESC
                    HUD
                   DESC
  s.homepage     = "https://github.com/RRRenJ/RRRTipsHUD.git"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "RRRenJ" => "https://github.com/RRRenJ" }
  s.source       = { :git => "https://github.com/RRRenJ/RRRTipsHUD.git", :tag => s.version }


  s.source_files  = "RRRTipsHUD/*.swift"
  s.resource     = 'RRRTipsHUD/images.xcassets'
  s.frameworks   = 'UIKit', 'Foundation'
  s.swift_version = '5.0'
  s.ios.deployment_target = '10.0'
    

end
