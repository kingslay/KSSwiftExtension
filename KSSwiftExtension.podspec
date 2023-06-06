#
#
Pod::Spec.new do |s|
  s.name             = 'KSSwiftExtension'
  s.version          = '1.1.7'
  s.summary          = "UIKit 's Extension"
  s.description      = <<-DESC
    KSSwiftExtension is a Extension of UIKit
                       DESC
  s.homepage         = 'https://github.com/kingslay/KSSwiftExtension.git'
  s.license          = 'MIT'
  s.author           = { 'kingslay' => 'kingslay@icloud.com' }
  s.source           = { :git => 'https://github.com/kingslay/KSSwiftExtension.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.default_subspec = "Core"
  s.subspec "Core" do |ss|
    ss.source_files  = 'Core/Source/**/*.swift'
  end
  s.subspec "RxSwift" do |ss|
    ss.source_files  = "RxSwift/Source/**/*.swift"
    ss.dependency "KSSwiftExtension/Core"
    ss.dependency "RxSwift"
  end
  s.subspec "RxCocoa" do |ss|
    ss.source_files  = "RxCocoa/Source/**/*.swift"
    ss.dependency "KSSwiftExtension/RxSwift"
    ss.dependency "RxCocoa"
  end
  s.subspec "ViewKit" do |ss|
    ss.source_files  = "ViewKit/Source/**/*.swift"
    ss.resources = 'ViewKit/Resource/*.{json,png,jpg,gif,js}'
    ss.dependency "KSSwiftExtension/Core"
  end
end
