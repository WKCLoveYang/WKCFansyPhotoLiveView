Pod::Spec.new do |s|
s.name         = "WKCFansyPhotoLiveView"
s.version      = "1.0.1"
s.summary      = "WKCFansyPhotoLiveView is a view for livwPhoto."
s.homepage     = "https://github.com/WKCLoveYang/WKCFansyPhotoLiveView.git"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "WKCLoveYang" => "wkcloveyang@gmail.com" }
s.platform     = :ios, "10.0"
s.source       = { :git => "https://github.com/WKCLoveYang/WKCFansyPhotoLiveView.git", :tag => "1.0.1" }
s.source_files  = "WKCFansyPhotoLiveView/**/*.{h,m}"
s.public_header_files = "WKCFansyPhotoLiveView/**/*.h"
s.frameworks = "Foundation", "UIKit", "Photos", "PhotosUI"
s.requires_arc = true
s.dependency "AFNetworking"
s.dependency "SDWebImage"

end
