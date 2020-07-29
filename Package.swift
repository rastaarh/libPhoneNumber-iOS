// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

// 3
let package = Package(
  // 4
  name: "libPhoneNumberiOS",
  // 5
  platforms: [
        .macOS(.v10_10),
        .iOS(.v8),
        .tvOS(.v9),
        .watchOS(.v2)
  ],
  // 6
  products: [
    .library(name: "libPhoneNumberiOS", targets: ["libPhoneNumberiOS"])
  ],
  // 7
  dependencies: []
  // 8
  targets: [
    .target(name: "libPhoneNumberiOS"),
    .testTarget(
      name: "libPhoneNumberiOSTests", 
      dependencies: ["libPhoneNumberiOS"]
    )
  ]
)

// let geocodingPackage = Package(
//     name: "libPhoneNumberGeocoding",
//     platforms: [
//         .macOS(.v10_10),
//         .iOS(.v8),
//         .tvOS(.v9),
//         .watchOS(.v2)
//     ],
//     products: [
//         .library(
//             name: "libPhoneNumberiOS",
//             targets: ["libPhoneNumberiOS"]
//         )
//     ],
//     targets: [
//         .target(
//             name: "libPhoneNumberGeocoding",
//             path: "libPhoneNumberGeocoding"
//         ),
//         .testTarget(
//             name: "libPhoneNumberGeocodingTests",
//             dependencies: ["libPhoneNumberGeocoding"],
//             path: "libPhoneNumberGeocodingTests",
//             sources: [
//                 "NBPhoneNumberOfflineGeocoderTest.m"
//             ]
//         )
//     ]
// )

// let shortNumberPackage = Package(
//     name: "libPhoneNumberShortNumber",
//     platforms: [
//         .macOS(.v10_10),
//         .iOS(.v8),
//         .tvOS(.v9),
//         .watchOS(.v2)
//     ],
//     products: [
//         .library(
//             name: "libPhoneNumberiOS",
//             targets: ["libPhoneNumberiOS"]
//         )
//     ],
//     targets: [
//         .target(
//             name: "libPhoneNumberShortNumber",
//             path: "libPhoneNumberShortNumber"
//         ),
//         .testTarget(
//             name: "libPhoneNumberShortNumberTests",
//             dependencies: ["libPhoneNumberShortNumber"],
//             path: "libPhoneNumberShortNumberTests",
//             sources: [
//                 "NBShortNumberInfoTest.m",
//                 "NBShortNumberTestHelper.h",
//                 "NBShortNumberTestHelper.m"
//             ]
//         )
//     ]
// )
