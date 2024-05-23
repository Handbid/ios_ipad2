# Data Persistence and Management System

### Components

1. **DatabaseService**: Handles low-level database operations including save, fetch, update, and delete.
2. **DataManager**: Provides a higher-level interface for data manipulation tasks and integrates a notification system for data changes.
3. **ModelType**: An enumeration that defines different types of data models in the system such as `user` and `auction`.

### Example Usage

#### Setup

Before using the `DataManager`, ensure that you have models defined that conform to `Codable` and `Identifiable`. Here's an example of such models:

```swift
struct UserModel: Codable, Identifiable {
    var id: String
    var name: String
    var email: String
}

struct AuctionModel: Codable, Identifiable {
    var id: String
    var title: String
    var startDate: Date
}
```

#### Creating a New Entry

To create a new user in the database:

```swift
let user = UserModel(id: "001", name: "John Doe", email: "john@example.com")
do {
    try DataManager.shared.create(user, in: .user)
} catch {
    print("Failed to create user: \(error)")
}
```

#### Fetching Entries

To fetch all users:

```swift
do {
    let users = try DataManager.shared.fetchAll(of: UserModel.self, from: .user)
    print("Fetched users: \(users)")
} catch {
    print("Failed to fetch users: \(error)")
}
```

#### Updating an Entry

To update an existing user:

```swift
var user = UserModel(id: "001", name: "Johnathan Doe", email: "johnathan@example.com")
do {
    try DataManager.shared.update(user, withNestedUpdates: true, in: .user)
} catch {
    print("Failed to update user: \(error)")
}
```

#### Deleting an Entry

To delete a user:

```swift
let user = UserModel(id: "001", name: "John Doe", email: "john@example.com")
do {
    try DataManager.shared.delete(user, from: .user)
} catch {
    print("Failed to delete user: \(error)")
}
```

#### Deleting all Entry

To delete a user:

```swift
do {
    try DataManager.shared.deleteAll(of: UserModel.self, from: .user)
} catch {
    print("Failed to delete user: \(error)")
}
```

#### Reacting to Data Changes

To observe changes in the data:

```swift
let cancellable = DataManager.shared.onDataChanged.sink {
    print("Data has changed!")
}
```

### Integrating with SwiftUI

To use `DataManager` within SwiftUI, you can access it through the environment:

```swift
struct ContentView: View {
    @Environment(\.dataManager) var dataManager

    var body: some View {
        Text("Data Manager is ready.")
            .onAppear {
                // Use dataManager as needed
            }
    }
}
```

This documentation should help developers understand and utilize the provided system effectively for managing data models within a SwiftUI application.
