//
//  AppDelegate.swift
//  TvMazeApp
//
//  Created by Guilherme Souza on 23/04/21.
//

import AppFeature
import Sentry
import UIKit

#if DEBUG
  let isDebug = true
#else
  let isDebug = false
#endif

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
      options.debug = isDebug
    }

    window = UIWindow(frame: UIScreen.main.bounds)
    appCoordinator = AppCoordinator(window: window!)
    appCoordinator.start()

    return true
  }
}
