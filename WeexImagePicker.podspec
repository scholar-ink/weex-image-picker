# coding: utf-8

Pod::Spec.new do |s|
  s.name         = "WeexImagePicker"
  s.version      = "0.0.4"
  s.summary      = "Weex Plugin"

  s.description  = <<-DESC
                   Weexplugin Source Description
                   DESC

  s.homepage     = "https://github.com/scholar-ink/weex-image-picker.git"
  s.license = {
    :type => 'Copyright',
    :text => <<-LICENSE
            copyright
    LICENSE
  }
  s.authors      = {
                     "yourname" =>"youreamail"
                   }
  s.platform     = :ios
  s.ios.deployment_target = "8.0"
  s.source       = { :git => s.homepage, :tag =>  s.version }
  s.source_files  = "ios/Sources/*.{h,m,mm}"
  
  s.requires_arc = true
  s.dependency "WeexPluginLoader"
  s.dependency "WeexSDK"
  s.dependency 'SDWebImage'
  s.dependency "ZLPhotoBrowser"
  s.dependency "AFNetworking"
end
