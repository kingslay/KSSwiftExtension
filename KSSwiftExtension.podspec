#
#
Pod::Spec.new do |s|
  s.name             = "KSSwiftExtension"
  s.version          = "0.5.0"
  s.summary          = "UIKit 's Extension"

  s.description      = <<-DESC
    KSSwiftExtension is a Extension of UIKit
                       DESC

  s.homepage         = "https://github.com/kingslay/KSSwiftExtension.git"
  s.license          = 'MIT'
  s.author           = { "kingslay" => "kingslay@icloud.com" }
  s.source           = { :git => "https://github.com/kingslay/KSSwiftExtension.git", :tag => s.version.to_s }
  s.ios.deployment_target = "8.0"
  s.tvos.deployment_target = "9.0"
  s.source_files = 'Source/**/*.{c,h,m,swift}'
  s.resources = 'Resource/*.{xib,json,png,jpg,gif,js}'
	s.dependency 'RxCocoa'
end
