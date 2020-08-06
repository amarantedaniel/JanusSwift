Pod::Spec.new do |spec|
    spec.name         = "JanusSwift"
    spec.version      = "0.0.6"
    spec.summary      = "A Swift wrapper for Janus RESTful API."
    spec.description  = <<-DESC
    A Swift wrapper for Janus RESTful API.

    Currently supporting the streaming plugin.
    DESC
    spec.homepage     = "https://github.com/amarantedaniel/JanusSwift"
    spec.license      = { :type => "MIT", :file => "LICENSE" }
    spec.author             = { "Daniel Amarante" => "daniel.amarante2@gmail.com" }
    spec.platforms = { :ios => "13.0", :osx => "10.14" }
    spec.swift_version = "5.2"
    spec.source       = { 
        :git => "https://github.com/amarantedaniel/JanusSwift.git", 
        :tag => "#{spec.version}" 
    }
    spec.source_files  = "Sources/Janus/**/*.swift"
end
