platform :ios, '9.0'

target 'SDAutoLayoutDemo' do
  pod 'AFNetworking', '~> 4.0'
  pod 'MJRefresh'
  pod 'MJExtension'

  target 'SDAutoLayoutDemoTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end

  # Apple SDK marks netinet6/in6.h as private when using modules; netinet/in.h is sufficient.
  %w[
    AFNetworking/AFNetworking/AFHTTPSessionManager.m
    AFNetworking/AFNetworking/AFNetworkReachabilityManager.m
  ].each do |rel|
    path = installer.sandbox.root + rel
    next unless File.exist?(path)
    contents = File.read(path)
    patched = contents.gsub(/^#import <netinet6\/in6\.h>\n/, '')
    File.write(path, patched) if patched != contents
  end
end
