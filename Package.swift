// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "followdown",
    products: [
        .executable(name: "followdown", targets: ["followdown"])
    ],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/ShellOut.git", from: "2.0.0")
    ],
    targets: [
        .target(
            name: "followdown",
            dependencies: ["ShellOut"]
        )
    ]
)
