//
//  APNSMessengerApp.swift
//  APNSMessenger
//
//  Created by Thinh Nguyen on 2/20/21.
//

import SwiftUI

@main
struct APNSClientApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
