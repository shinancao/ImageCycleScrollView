Pod::Spec.new do |s|

  s.name         = "ImageCycleScrollView"
  s.version      = "2.0"
  s.summary      = "A cycle scrollview in swift supporting autoplay and manual play."
  s.homepage     = "https://github.com/shinancao/ImageCycleScrollView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "shinancao" => "shinancao666@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/shinancao/ImageCycleScrollView.git", :tag => "#{s.version}" }
  s.source_files = "Sources/*.{swift,h}"
  s.frameworks   = "UIKit", "Foundation" 
  s.requires_arc = true
  s.dependency "Kingfisher", "~> 3.0"
  
end
