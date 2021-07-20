import Logger
import UIKit

public protocol PresentableError: Error {
  var errorMessage: String { get }
}

extension UIViewController {
  public func presentErrorAlert(_ error: Error, retryHandler: (() -> Void)?) {
    let message = (error as? PresentableError)?.errorMessage

    if message == nil {
      Logger.main.warning("Unhandled error being presented: \(error)")
    }

    let alertController = UIAlertController(
      title: "Oops!",
      message: "An unexpected error ocurred, please try again.",
      preferredStyle: .alert
    )

    let action: UIAlertAction

    if let retryHandler = retryHandler {
      action = UIAlertAction(title: "Try again", style: .default) { _ in
        retryHandler()
      }
    } else {
      action = UIAlertAction(title: "Ok", style: .default)
    }

    alertController.addAction(action)

    present(alertController, animated: true)
  }
}
