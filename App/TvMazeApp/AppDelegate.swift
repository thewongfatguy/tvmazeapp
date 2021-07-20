//
//  AppDelegate.swift
//  TvMazeApp
//
//  Created by Guilherme Souza on 23/04/21.
//

import AppFeature
import Logger
import Sentry
import UIKit

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var appCoordinator: AppCoordinator!

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    SentrySDK.start { options in
      options.dsn = Secrets.sentryDsn
      options.tracesSampleRate = 1.0
    }

    Logger.main = Logger(system: "dev.grds.tvmazeapp", destinations: [.console(), .sentry])

    window = UIWindow(frame: UIScreen.main.bounds)
    appCoordinator = AppCoordinator(window: window!)
    appCoordinator.start()

    return true
  }
}

extension Logger.Destination {
  static let sentry = Logger.Destination { msg in
    SentrySDK.capture(message: Logger.Formatter.default.format(msg))
  }
}
