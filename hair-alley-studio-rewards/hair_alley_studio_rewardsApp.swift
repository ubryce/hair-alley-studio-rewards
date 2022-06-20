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

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
