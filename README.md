
# TvMaze App

This is an app built as a coding challenge, it was built with simplicity in mind and to showcase some of my knowledges.


## Getting started 

To run it locally just clone the repository and open the `TvMazeApp.xcworkspace` in `Xcode`.

```bash 
  git clone https://github.com/grsouza/tvmazeapp
  cd tvmazeapp
  open -a Xcode TvMazeApp.xcworkspace
```

The project uses [SPM](https://swift.org/package-manager/) for package management, so there is no need for installing an external tool like `Cocoapods` or `Carthage`.
    

## Documentation

The root directory contains:

* `App`: The main application target, contains only the AppDelegate and has the single purpose of bootstraping the application.
* `Makefile`: A simple Makefile to automate some tasks, like running tests and formatting code.
* `README.md`: The file you are reading now.
* `TvMazeApp.xcworkspace`: The Xcode's workspace that should be opened on Xcode, it contains the main project and SPM package.
* `TvMazeAppLib`: This is the main SPM package, where all the important code resides.

```
.
├── App
├── Makefile
├── README.md
├── TvMazeApp.xcworkspace
└── TvMazeAppLib
```

The project structure is very simple, it consists of a main application target that contains only the `AppDelegate` and has the purpose of starting up the application and forward to the `AppCoordinator` class.

### The SPM modules

If you take a look at `./TvMazeAppLib/Package.swift` you will see the definition of all submodules that forms the application, here is an overview of each of them.

* `ApiClient`: contains all the code related to the communication with the `TvMaze` REST api.
* `AppEnvironment`: contains a definition of all the application environment and it's dependencies, heavly inspired on this talk from the guys at pointfree (https://www.pointfree.co/blog/posts/21-how-to-control-the-world).
* `AppFeature`: contains the entry point of the application, it's the module that the `AppDelegate` calls once the app has started.
* `EpisodesFeature`: contains screens and logic related to the episodes list and details.
* `Helpers`: some helpers and common codes to all modules.
* `L10n`: consists of the string resources used thoughout the applications, the app is not localized, but it's a supported feature since day 1.
* `Models`: contains some domain modules used by the features modules.
* `ShowFeature`: contains screens and logic related to the shows list and details.
* `TestSupport`: contains some test related helpers, used by the unit test targets, basically consists of a mock implementaion of the `AppEnvironment`.


```
.
├── ApiClient
├── AppEnvironment
├── AppFeature
├── EpisodesFeature
├── Helpers
├── L10n
├── Models
├── ShowFeature
└── TestSupport
```

### Architectural decisions

The application is built using `MVVM + Coordinator` and using `Combine` for communication between the layers.
