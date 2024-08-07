// swift-tools-version: 5.8

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "theo",
    platforms: [
        .iOS("16.0")
    ],
    products: [
        .iOSApplication(
            name: "theo",
            targets: ["AppModule"],
            bundleIdentifier: "com.TimonHarz.theo",
            teamIdentifier: "9N56URLU8K",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.mint),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                .speechRecognition(purposeString: "Speech Recognition will be used to turn spoken content into morse code, to provide haptic feedback."),
                .microphone(purposeString: "The microphone will be used to detect if someone is speaking and if so start transcribing the spoken content."),
                .camera(purposeString: "The camera will be used to recognize text and directly translate it for you."),
                .motion(purposeString: "Motion data will be used to detect, whether you shaken the device, so we will return you to simple chat mode.")
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .process("Resources")
            ]
        )
    ]
)