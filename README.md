# CBHWindowManager

[![release](https://img.shields.io/github/release/chris-huxtable/CBHWindowManager.svg)](https://github.com/chris-huxtable/CBHWindowManager/releases)
[![pod](https://img.shields.io/cocoapods/v/CBHWindowManager.svg)](https://cocoapods.org/pods/CBHWindowManager)
[![licence](https://img.shields.io/badge/licence-ISC-lightgrey.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHWindowManager/blob/master/LICENSE)
[![coverage](https://img.shields.io/badge/coverage-100%25-brightgreen.svg?cacheSeconds=2592000)](https://github.com/chris-huxtable/CBHWindowManager)

An easy-to-use singleton which manages `NSWindow` and `NSWindowController` objects.


## Examples:

Adding a controller so that once the window is closed both the window and controller are released.
```objective-c
SomeWindowController *controller = [[[SomeWindowController class] alloc] initWithWindowNibName:@"SomeWindowNibName"];
[[CBHWindowManager sharedManager] manageController:controller];
```

Adding a controller with a key so that it may be found by name.
```objective-c
/// Create and adding the controller withe key.
SomeWindowController *controller = [[[SomeWindowController class] alloc] initWithWindowNibName:@"SomeWindowNibName"];
[[CBHWindowManager sharedManager] manageController:controller withKey:@"SomeWindowKey"];

// ...

/// Lookup the controller
SomeWindowController *controller = [[CBHWindowManager sharedManager] controllerForKey:@"SomeWindowKey"];
```

Finding a controller with a key and if not creating and adding one.
```objective-c
/// Lookup the controller in the manager. If it's found, return early.
SomeWindowController *controller = (SomeWindowController *)[[CBHWindowManager sharedManager] controllerForKey:@"SomeWindowKey"];
if ( controller ) { return controller; }

/// If the controller is not in the manager create it and add it to the manger.
controller = [[[SomeWindowController class] alloc] initWithWindowNibName:@"SomeWindowNibName"];
[[CBHWindowManager sharedManager] manageController:controller withKey:@"SomeWindowKey"];
return controller;
```

## Licence
CBHWindowManager is available under the [ISC license](https://github.com/chris-huxtable/CBHWindowManager/blob/master/LICENSE).
