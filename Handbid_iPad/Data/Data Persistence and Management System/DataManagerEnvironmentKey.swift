// Copyright (c) 2024 by Handbid. All rights reserved.

import SwiftUI

struct DataManagerEnvironmentKey: EnvironmentKey {
	static let defaultValue: DataManager = .shared
}

extension EnvironmentValues {
	var dataManager: DataManager {
		get { self[DataManagerEnvironmentKey.self] }
		set { self[DataManagerEnvironmentKey.self] = newValue }
	}
}



import SwiftData

@Model
class Task {
    @Attribute(.unique) var id: UUID
    var title: String
    var isCompleted: Bool

    init(id: UUID = UUID(), title: String, isCompleted: Bool = false) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}

class PersistenceController {
    static let shared = PersistenceController()

    let container: ModelContainer

    private init() {
        do {
            container = try ModelContainer(for: Task.self)
        } catch {
            fatalError("Failed to initialize ModelContainer: \(error)")
        }
    }
}

@MainActor
class TaskManager: ObservableObject {
    private let context: ModelContext

    init(context: ModelContext? = nil) {
        if let context = context {
            self.context = context
        } else {
            self.context = PersistenceController.shared.container.mainContext
        }
    }

    func addTask(title: String) {
        let newTask = Task(title: title)
        context.insert(newTask)
        saveContext()
    }

    func deleteTask(task: Task) {
        context.delete(task)
        saveContext()
    }

    func toggleTaskCompletion(task: Task) {
        task.isCompleted.toggle()
        saveContext()
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

    func fetchTasks() -> [Task] {
        let fetchDescriptor = FetchDescriptor<Task>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch tasks: \(error)")
            return []
        }
    }
}
