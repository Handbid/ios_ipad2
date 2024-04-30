// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "NetworkService",
	platforms: [.iOS(.v17), .macOS(.v14), .watchOS(.v10), .tvOS(.v17)],
	products: [.library(name: "NetworkService", targets: ["NetworkService"])],
	dependencies: [
		.package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
	],
	targets: [
		.target(name: "NetworkService", dependencies: ["KeychainAccess"], path: "Sources", resources: [.copy("PrivacyInfo.xcprivacy")]),
		.testTarget(name: "NetworkServiceTests", dependencies: ["NetworkService"]),
	]
)
