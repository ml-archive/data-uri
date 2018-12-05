# DataURI
[![Swift Version](https://img.shields.io/badge/Swift-4-brightgreen.svg)](http://swift.org)
[![Vapor Version](https://img.shields.io/badge/Vapor-3-30B6FC.svg)](http://vapor.codes)
[![Circle CI](https://circleci.com/gh/nodes-vapor/data-uri/tree/master.svg?style=shield)](https://circleci.com/gh/nodes-vapor/data-uri)
[![codebeat badge](https://codebeat.co/badges/7f0cab4f-f11b-43d5-8484-bc9300c23d81)](https://codebeat.co/projects/github-com-nodes-vapor-data-uri-master)
[![codecov](https://codecov.io/gh/nodes-vapor/data-uri/branch/master/graph/badge.svg)](https://codecov.io/gh/nodes-vapor/data-uri)
[![Readme Score](http://readme-score-api.herokuapp.com/score.svg?url=https://github.com/nodes-vapor/data-uri)](http://clayallsopp.github.io/readme-score?url=https://github.com/nodes-vapor/data-uri)
[![GitHub license](https://img.shields.io/badge/license-MIT-blue.svg)](https://raw.githubusercontent.com/nodes-vapor/data-uri/master/LICENSE)

A pure Swift parser for Data URIs.


## 📦 Installation

Update your `Package.swift` file.
```swift
.package(url: "https://github.com/nodes-vapor/data-uri.git", from: "2.0.0")
```


## Getting started 🚀

There are two options for decoding a Data URI. The first is using the `String` extension and the second is by using the `DataURIParser` directly.

### The `String` method

This method is by far the easiest to use. All you need to do is call `.dataURIDecoded() throws -> (data: Bytes, type: String)` on any Data URI encoded `String`.

```swift
import Core //just for `Bytes.string`
import DataURI

let uri = "data:,Hello%2C%20World!"
let (data, type) = try uri.dataURIDecoded()
print(data.string) // "Hello, World!"
print(type) // "text/plain;charset=US-ASCII"
```

### The `DataURIParser` method

Using the parser is a bit more involved as it returns all of its results as `Bytes`.

```swift
import Core //just for `Bytes.string`
import DataURI

let uri = "data:text/html,%3Ch1%3EHello%2C%20World!%3C%2Fh1%3E"
let (data, type, metadata) = try DataURIParser.parse(uri: uri)
print(data.string) // "<h1>Hello, World!</h1>"
print(type.string) // "text/html"
print(metadata == nil) // "true"
```


## 🏆 Credits

This package is developed and maintained by the Vapor team at [Nodes](https://www.nodesagency.com).
The package owner for this project is [Tom](https://github.com/tomserowka).


## 📄 License

This package is open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT)
