// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "libPhoneNumber",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v8),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(
            name: "libPhoneNumber",
            targets: ["libPhoneNumber"]
        )
    ],
    targets: [
        .target(
            name: "libPhoneNumber",
            path: "libPhoneNumber",
            publicHeadersPath: ".",
            cSettings: [
                .headerSearchPath("Internal")
            ]
        ),
        .testTarget(
            name: "libPhoneNumberTests",
            dependencies: ["libPhoneNumber"],
            path: "libPhoneNumberTests",
            sources: [
                "NBAsYouTypeFormatterTest.m",
                "NBPhoneNumberParsingPerfTest.m",
                "NBPhoneNumberUtilTest.m"
            ]
        ),
        .target(
            name: "libPhoneNumberGeocoding",
            dependencies: ["libPhoneNumber"],
            path: "libPhoneNumberGeocoding"
        ),
        .testTarget(
            name: "libPhoneNumberGeocodingTests",
            dependencies: ["libPhoneNumberGeocoding"],
            path: "libPhoneNumberGeocodingTests",
            sources: [
                "NBPhoneNumberOfflineGeocoderTest.m"
            ]
        ),
        .target(
            name: "libPhoneNumberShortNumber",
            dependencies: ["libPhoneNumber"],
            path: "libPhoneNumberShortNumber"
        ),
        .testTarget(
            name: "libPhoneNumberShortNumberTests",
            dependencies: ["libPhoneNumberShortNumber"],
            path: "libPhoneNumberShortNumberTests",
            sources: [
                "NBShortNumberInfoTest.m",
                "NBShortNumberTestHelper.h",
                "NBShortNumberTestHelper.m"
            ]
        )
    ]
)
