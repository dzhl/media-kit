#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint media_kit_libs_macos_video.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  podspec_dir = File.dirname(__FILE__)
  puts "=========================================================================="
  puts "[media_kit_libs_macos_video] 🌟 Starting automated build execution..."
  puts "[media_kit_libs_macos_video] Target directory: #{podspec_dir}"
  
  make_cmd = "cd '#{podspec_dir}' && make"
  puts "[media_kit_libs_macos_video] Executing command: #{make_cmd}"
  
  success = system(make_cmd)
  
  if success
    puts "[media_kit_libs_macos_video] ✅ Make executed successfully!"
    puts "[media_kit_libs_macos_video] Verifying extracted frameworks:"
    Dir.glob("#{podspec_dir}/Frameworks/*.xcframework").each do |fw|
      puts "  - Found Framework: #{File.basename(fw)}"
    end
    if File.directory?("#{podspec_dir}/Frameworks/.symlinks/mpv")
      puts "[media_kit_libs_macos_video] ✅ Verified .symlinks/mpv directory exists!"
    else
      puts "[media_kit_libs_macos_video] ⚠️ Warning: .symlinks/mpv directory missing!"
    end
  else
    puts "[media_kit_libs_macos_video] ❌ Make execution failed! Raising error..."
    raise "[media_kit_libs_macos_video] Fatal: Failed to execute make inside #{podspec_dir}"
  end
  puts "=========================================================================="

  s.name             = 'media_kit_libs_macos_video'
  s.version          = '1.1.5'
  s.summary          = 'macOS dependency package for package:media_kit'
  s.description      = <<-DESC
  macOS dependency package for package:media_kit.
                       DESC
  s.homepage         = 'https://github.com/media-kit/media-kit.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Hitesh Kumar Saini' => 'saini123hitesh@gmail.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'media_kit_libs_macos_video/Sources/media_kit_libs_macos_video/**/*.swift'
  s.dependency 'FlutterMacOS'
  s.resource_bundles = {
    'media_kit_libs_macos_video_privacy' => ['media_kit_libs_macos_video/Sources/media_kit_libs_macos_video/PrivacyInfo.xcprivacy']
  }

  s.vendored_frameworks = 'Frameworks/*.xcframework'

  s.platform = :osx, '10.9'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
