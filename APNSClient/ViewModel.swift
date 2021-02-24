//
//  ViewModel.swift
//  APNSMessenger
//
//  Created by Thinh Nguyen on 2/20/21.
//

import Foundation
import APNSwift
import Combine
import Logging
import NIO

class ViewModel: ObservableObject {
    let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)
    let apns: APNSwiftConnection?
    let logger = Logger(label: "com.prospertin.APNSMessenger")
    
    @Published var result: String? = nil    
    @Published var message: Message = Message()
    @Published var token: String = ""
    
    init() {
        do {
            let apnsConfig = try ViewModel.configTokenMethod()
            apns = try APNSwiftConnection.connect(configuration: apnsConfig, on: group.next()).wait()
        } catch {
            // Handle errors
            logger.error("Cannot init apns: \(error.localizedDescription)")
            apns = nil
        }
    }
    
    func sendNotification() {
        print("*** Model: \(token) Message: \(message)")
        let alert = APNSwiftAlert(title: message.title, subtitle: message.subtitle, body: message.body)
        let apsSound = APNSSoundDictionary(isCritical: true, name: "cow.wav", volume: 0.8)
        let aps = APNSwiftPayload(alert: alert, badge: 0, sound: .critical(apsSound), hasContentAvailable: true)
        let notification = AcmeNotification(data: message.data, aps: aps)
        do {
            let expiry = Date().addingTimeInterval(5)
            guard let apns = apns else {
                result = "APNS not initialized!"
                return
            }
            try apns.send(
                notification,
                pushType: .alert,
                to: token,
                expiration: expiry,
                priority: 10
            )
            .wait()
            result = "Message successfully sent"
        } catch {
            // Error
            result = "Error: \(error)"
        }
    }
}

extension ViewModel {
    static func configTokenMethod() throws -> APNSwiftConfiguration {
        // optional
        var logger = Logger(label: "com.apnswift")
        logger.logLevel = .debug
    
        return try APNSwiftConfiguration(
            authenticationMethod: .jwt(
                key: .private(filePath: "/Users/thinhnguyen/Downloads/AuthKey_38K4CF2WAR.p8"),
                keyIdentifier: "38K4CF2WAR",
                teamIdentifier: "TMG5A4ZFBZ"
            ),
            topic: "com.prospertin.Voyager",
            environment: .sandbox,
            logger: logger
        )
    }
}

struct AcmeNotification: APNSwiftNotification {
    let data: [String]
    let aps: APNSwiftPayload

    init(data: [String], aps: APNSwiftPayload) {
        self.data = data
        self.aps = aps
    }
}

struct Message {
    var title: String
    var subtitle: String?
    var body: String
    var data: [String] // Could be object
    
    init(title: String = "", subtitle: String? = nil, body: String = "", data: [String] = []) {
        self.title = title
        self.subtitle = subtitle
        self.body = body
        self.data = data
    }
}
