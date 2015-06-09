#
# Be sure to run `pod lib lint DZVideoPlayerViewController.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DZVideoPlayerViewController"
  s.version          = "0.2.1"
  s.summary          = "iOS Video Player control, implemented with AVPlayer."
  s.description      = <<-DESC
                       iOS Video Player control with playback controls, remote control center commands, background playback, now playing info updates. Implemented with AVPlayer, supports both online and offline videos. Highly customizable with Interface Builder.
                       DESC
  s.homepage         = "https://github.com/DZamataev/DZVideoPlayerViewController"
  s.screenshots     = "https://raw.githubusercontent.com/DZamataev/DZVideoPlayerViewController/master/Screenshots/screenshot1.1.png", "https://raw.githubusercontent.com/DZamataev/DZVideoPlayerViewController/master/Screenshots/screenshot2.1.png"
  s.license          = 'MIT'
  s.author           = { "Denis Zamataev" => "denis.zamataev@gmail.com" }
  s.source           = { :git => "https://github.com/DZamataev/DZVideoPlayerViewController.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/dzamataev'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DZVideoPlayerViewController' => ['Pod/Assets/**/*']
  }

  s.frameworks = 'AVFoundation', 'AudioToolbox'
end
