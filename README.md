# JanusSwift

A Swift wrapper around [Janus RESTful API](https://janus.conf.meetecho.com/docs/rest.html).


## Installation

### CocoaPods

If your project uses [CocoaPods](https://cocoapods.org), just add the following to your `Podfile`:

``` ruby
pod "JanusSwift", '~> 0.0.6'
```

### SwiftPM

If your project uses [SwiftPM](https://swift.org/package-manager/), just add the following as adding a `dependencies` clause to your `Package.swift`:

``` swift
dependencies: [
  .package(url: "https://github.com/amarantedaniel/JanusSwift.git", from: "0.0.6")
]
```

## Available Plugins

Currently the only supported plugin is streaming and not all of the routes are there yet.

## Example App

There is an example on how to integrate Janus streaming plugin with WebRTC using SwiftUI.
