// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CLICK",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
    ],
    products: [
        .library(
            name: "ClickAI",
            targets: ["ClickAI"]
        ),
    ],
    targets: [
        .target(
            name: "ClickAI",
            path: "ClickAI",
            exclude: ["Resources"],
            resources: [
                .copy("Assets/FoodOatmeal.jpg"),
                .copy("Assets/FoodBowl.jpg"),
                .copy("Assets/FoodSalmon.jpg"),
                .copy("Assets/FoodSalad.jpg"),
                .copy("Assets/TrainingCover.jpg"),
                .copy("Assets/Manrope.ttf"),
                .copy("Assets/Unbounded.ttf"),
            ]
        ),
    ]
)

