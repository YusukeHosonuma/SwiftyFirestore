Pod::Spec.new do |spec|
    spec.name         = "SwiftyFirestore"
    spec.version      = "0.0.1"
    spec.summary      = "Swifty framework for Firestore"

    spec.description  = <<-DESC
    Swifty framework for Firestore a.k.a Firestore on S(wift) strings.
    DESC

    spec.homepage         = "https://github.com/YusukeHosonuma/SwiftyFirestore"
    spec.license          = { :type => 'MIT', :file => 'LICENSE' }
    spec.authors          = { "Yusuke Hosonuma" => "tobi462@gmail.com" }
    spec.social_media_url = "https://twitter.com/tobi462"

    spec.ios.deployment_target = "8.0"

    spec.cocoapods_version  = '>= 1.4.0'
    spec.static_framework   = true
    spec.prefix_header_file = false

    spec.source = { :git => "https://github.com/YusukeHosonuma/SwiftyFirestore.git", :tag => "#{spec.version}" }
    spec.source_files  = "Sources/SwiftyFirestore/**/*.{swift}"
    spec.swift_version = "5.1"

    spec.dependency 'FirebaseFirestoreSwift', '>= 0.2'
  end
