//
//  APNSMessengerApp.swift
//  APNSMessenger
//
//  Created by Thinh Nguyen on 2/20/21.
//

import SwiftUI

var appDelegate = AppDelegate()

//@main
//struct APNSClientApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView(viewModel: ViewModel())
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//    }
//}

@main
struct AppUserInterfaceSelector {
    static func main() {
        if #available(OSX 11.0, *) {
            APNSClientApp.main()
        } else {
            NSApplication.shared.setActivationPolicy(.regular)
            NSApp.delegate = appDelegate
            NSApp.activate(ignoringOtherApps: true)
            NSApp.run()
        }
    }
}

@available(OSX 11.0, *)
struct APNSClientApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ViewModel())
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView(viewModel: ViewModel())
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        // Create the window and set the content view.
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)

        window.title = "APNS Client"
        window.isReleasedWhenClosed = false
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView)
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {  }
}
