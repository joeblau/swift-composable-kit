# ComposableFast

A [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture) implementation of a fast.com speed test library.


### Setup

Import
```swift
import ComposableFast
```

Create Fast Manager id

```swift
struct FastManagerId: Hashable {}
```

Add Fast Manager to AppEnvironment

```swift
struct AppEnvironment {
    ...
    let fastManager: FastManager
    ...
}
```

### Life-cycle

Create Fast Manager

```swift 
environment.fastManager.create(id: FastManagerId()).map(AppAction.fastManager)
```

Destroy Fast Manager

```swift
environment.fastManager.destroy(id: FastManagerId()).fireAndForget(),
``` 

### Operations

Start Speed Test

```swift
environment.fastManager.startTest(id: FastManagerId()).fireAndForget()
```

Stop Speed Test

```swift
environment.fastManager.stopTest(id: FastManagerId()).fireAndForget()
```

### Callbacks

```swift
case let .didReceive(message: message):
    guard let body = message.body as? NSDictionary,
          let type = body["type"] as? String,
          let units = body["units"] as? String,
          let value = body["value"] as? String else {  return .none }
    
    switch type {
    case "down":
    	// handle download update
        return .none

    case "down-done":
         // handle download completion
        return .none
        
    case "up":
        // handle upload update
        return .none

    case "up-done":
        // handle upload completion
    default:
        return .none
    }
}
```