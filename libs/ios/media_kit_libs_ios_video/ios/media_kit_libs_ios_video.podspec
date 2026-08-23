#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint media_kit_libs_ios_video.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  symlink_dir = File.dirname(__FILE__)
  realpath_dir = File.realpath(File.dirname(__FILE__))
  puts "=========================================================================="
  puts "[media_kit_libs_ios_video] 🌟 Starting automated build execution..."
  puts "[media_kit_libs_ios_video] Symlink dir : #{symlink_dir}"
  puts "[media_kit_libs_ios_video] Realpath dir: #{realpath_dir}"
  
  make_cmd = "cd '#{symlink_dir}' && make"
  puts "[media_kit_libs_ios_video] Executing command: #{make_cmd}"
  success = system(make_cmd)

  if realpath_dir != symlink_dir
    make_cmd_real = "cd '#{realpath_dir}' && make"
    puts "[media_kit_libs_ios_video] Executing realpath command: #{make_cmd_real}"
    system(make_cmd_real)
  end

  if success
    puts "[media_kit_libs_ios_video] ✅ Make executed successfully!"
    [symlink_dir, realpath_dir].uniq.each do |target_dir|
      puts "[media_kit_libs_ios_video] 🔍 Checking frameworks in: #{target_dir}"
      Dir.glob("#{target_dir}/Frameworks/*.xcframework").each do |fw|
        puts "  - Found Framework: #{File.basename(fw)}"
        Dir.glob("#{fw}/*").each do |sub|
          puts "    - Subdir: #{File.basename(sub)}" if File.directory?(sub)
        end
      end
      mpv_symlink_dir = "#{target_dir}/Frameworks/.symlinks/mpv"
      if File.directory?(mpv_symlink_dir)
        puts "[media_kit_libs_ios_video] ✅ Verified .symlinks/mpv directory exists in #{target_dir}!"
        Dir.glob("#{mpv_symlink_dir}/*").each do |sl|
          target = File.readlink(sl) rescue "N/A"
          exists = File.exist?(sl)
          puts "  - Symlink: #{File.basename(sl)} -> #{target} (Valid: #{exists})"
        end
      else
        puts "[media_kit_libs_ios_video] ⚠️ Warning: .symlinks/mpv directory missing in #{target_dir}!"
      end
    end
  else
    puts "[media_kit_libs_ios_video] ❌ Make execution failed! Raising error..."
    raise "[media_kit_libs_ios_video] Fatal: Failed to execute make inside #{symlink_dir}"
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
