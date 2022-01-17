// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "AbnormalMouseWebsite",
    products: [
        .executable(
            name: "AbnormalMouseWebsite",
            targets: ["AbnormalMouseWebsite"]
        )
    ],
    dependencies: [
        .package(name: "Publish", url: "https://github.com/johnsundell/publish.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "AbnormalMouseWebsite",
            dependencies: ["Publish"]
        )
    ]
)
