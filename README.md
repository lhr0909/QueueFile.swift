# QueueFile for iOS/macOS

A Swift wrapper for [queue-file](https://github.com/ing-systems/queue-file), a lightning-fast, transactional, file-based FIFO queue written in Rust. Uses [UniFFI](https://github.com/mozilla/uniffi-rs) to generate Swift bindings.

## Features

- Persistent FIFO queue backed by a single file
- Atomic operations - changes are transactional
- Thread-safe with Swift `actor` isolation
- Generic `CodableQueueFile<T>` for automatic JSON serialization of Swift types
- Compatible with Square's [Tape2](https://github.com/square/tape) Java library

## Installation

### Swift Package Manager

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/example/QueueFile.swift.git", from: "0.1.0")
]
```

Or add it via Xcode: File → Add Package Dependencies → Enter the repository URL.

## Usage

### Raw Data Queue

```swift
import QueueFileSwift

// Create or open a queue
let queue = try QueueFileSwiftQueue(path: "/path/to/queue.qf")

// Add data
let data = "Hello, World!".data(using: .utf8)!
try await queue.add(data)

// Peek at the oldest item (without removing)
if let peeked = try await queue.peek() {
    print(String(data: peeked, encoding: .utf8)!)
}

// Remove the oldest item
try await queue.remove()

// Check queue state
let isEmpty = try await queue.isEmpty()
let count = try await queue.size()

// Get all items
let allItems = try await queue.getAll()

// Clear the queue
try await queue.clear()
```

### Typed Queue with Codable

```swift
import QueueFileSwift

struct Task: Codable, Sendable {
    let id: String
    let priority: Int
    let payload: String
}

// Create a typed queue
let taskQueue = try CodableQueueFile<Task>(path: "/path/to/tasks.qf")

// Add items (automatically serialized to JSON)
try await taskQueue.add(Task(id: "1", priority: 1, payload: "Do something"))
try await taskQueue.add(Task(id: "2", priority: 2, payload: "Do something else"))

// Peek returns the typed object
if let task = try await taskQueue.peek() {
    print("Next task: \(task.id) - \(task.payload)")
}

// Get all items as typed array
let allTasks = try await taskQueue.getAll()
```

### Configuration Options

```swift
let queue = try QueueFileSwiftQueue(path: path)

// Sync writes to disk immediately (slower but safer)
try await queue.setSyncWrites(true)

// Overwrite data on remove (for sensitive data)
try await queue.setOverwriteOnRemove(true)

// Configure offset caching for faster iteration
try await queue.setCacheOffsetPolicy(.quadratic)
// or
try await queue.setCacheOffsetPolicy(.linear(offset: 100))
```

## Development

### Prerequisites

- Rust toolchain with iOS targets
- Xcode with Swift 6.0+

### Building

```bash
# Install Rust targets (if not already done via rust-toolchain.toml)
rustup target add aarch64-apple-ios aarch64-apple-ios-sim aarch64-apple-darwin

# Build everything (Rust lib + Swift bindings + XCFramework)
./build-ios.sh

# Run tests
swift test
```

### Project Structure

```
QueueFile.swift/
├── src/
│   ├── lib.rs              # Rust FFI implementation
│   └── uniffi-bindgen.rs   # UniFFI code generator
├── Sources/
│   ├── QueueFileFFI/       # Auto-generated Swift bindings
│   └── QueueFileSwift/     # Hand-written Swift wrapper
├── Tests/
│   └── QueueFileSwiftTests/
├── build-ios.sh            # Build script
├── Cargo.toml              # Rust dependencies
└── Package.swift           # Swift package manifest
```

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- [queue-file](https://github.com/ing-systems/queue-file) - The underlying Rust implementation
- [Tape2](https://github.com/square/tape) - Original Java implementation by Square
- [UniFFI](https://github.com/mozilla/uniffi-rs) - Mozilla's FFI bindings generator
