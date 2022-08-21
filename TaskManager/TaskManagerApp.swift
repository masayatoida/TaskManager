//
//  TaskManagerApp.swift
//  TaskManager
//
//  Created by 戸井田莉江 on 2022/08/21.
//

import SwiftUI

@main
struct TaskManagerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
