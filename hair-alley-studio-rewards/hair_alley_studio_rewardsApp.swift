//
//  hair_alley_studio_rewardsApp.swift
//  hair-alley-studio-rewards
//
//  Created by Bryce Nguyen on 2022-06-17.
//

import SwiftUI
@main
struct hair_alley_studio_rewardsApp: App {
    let persistenceController = PersistenceController.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    let persistenceController = PersistenceController.shared
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    
    @MainActor func applicationDidFinishLaunching(_ notification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let statusButton = statusItem.button {
            //statusButton.image = NSImage(systemSymbolName: "chart.line.uptrend.xyaxis.circle", accessibilityDescription: "Chart Line")
            statusButton.image = NSImage(named: NSImage.Name("AppIcon"))
            statusButton.image?.size = NSMakeSize(16,16)
            statusButton.action = #selector(togglePopover)
        }
        
        self.popover = NSPopover()
        self.popover.contentSize = NSSize(width: 700, height: 350)
        self.popover.behavior = .transient
        self.popover.contentViewController = NSHostingController(rootView: ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext))
    }
    
    @objc func togglePopover() {
        
        
        
        if let button = statusItem.button {
            if popover.isShown {
                self.popover.performClose(nil)
            } else {
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}
