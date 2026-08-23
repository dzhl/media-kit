#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint media_kit_libs_ios_video.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  podspec_dir = File.dirname(__FILE__)
  puts "=========================================================================="
  puts "[media_kit_libs_ios_video] 🌟 Starting automated build execution..."
  puts "[media_kit_libs_ios_video] Target directory: #{podspec_dir}"
  
  make_cmd = "cd '#{podspec_dir}' && make"
  puts "[media_kit_libs_ios_video] Executing command: #{make_cmd}"
  
  success = system(make_cmd)
  
  if success
    puts "[media_kit_libs_ios_video] ✅ Make executed successfully!"
    puts "[media_kit_libs_ios_video] Verifying extracted frameworks:"
    Dir.glob("#{podspec_dir}/Frameworks/*.xcframework").each do |fw|
      puts "  - Found Framework: #{File.basename(fw)}"
    end
    if File.directory?("#{podspec_dir}/Frameworks/.symlinks/mpv")
      puts "[media_kit_libs_ios_video] ✅ Verified .symlinks/mpv directory exists!"
    else
      puts "[media_kit_libs_ios_video] ⚠️ Warning: .symlinks/mpv directory missing!"
    end
  else
    puts "[media_kit_libs_ios_video] ❌ Make execution failed! Raising error..."
    raise "[media_kit_libs_ios_video] Fatal: Failed to execute make inside #{podspec_dir}"
  end
  puts "=========================================================================="

  s.name             = 'media_kit_libs_ios_video'
  s.version          = '1.1.5'
  s.summary          = 'iOS dependency package for package:media_kit'
  s.description      = <<-DESC
  iOS dependency package for package:media_kit.
                       DESC
  s.homepage         = 'https://github.com/media-kit/media-kit.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Hitesh Kumar Saini' => 'saini123hitesh@gmail.com' }

  s.source           = { :path => '.' }
  s.source_files     = 'media_kit_libs_ios_video/Sources/media_kit_libs_ios_video/**/*.swift'
  s.dependency 'Flutter'
  s.resource_bundles = {
    'media_kit_libs_ios_video_privacy' => ['media_kit_libs_ios_video/Sources/media_kit_libs_ios_video/PrivacyInfo.xcprivacy']
  }

  s.vendored_frameworks = 'Frameworks/*.xcframework'

  s.platform = :ios, '9.0'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    # Flutter.framework does not contain a i386 slice.
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386',
  }
  s.swift_version = '5.0'
end
