import UIKit

extension String {
  func htmlAttributedString(
    size: CGFloat = UIFont.preferredFont(forTextStyle: .body).pointSize,
    color: UIColor = .label
  ) -> NSAttributedString? {
    let htmlTemplate = """
      <!doctype html>
      <html>
        <head>
          <style>
            body {
              font-family: -apple-system;
              font-size: \(size)px;
              color: \(color.cssString);
            }
          </style>
        </head>
        <body>
          \(self)
        </body>
      </html>
      """

    guard let data = htmlTemplate.data(using: .utf8) else {
      return nil
    }

    guard
      let attributedString = try? NSAttributedString(
        data: data,
        options: [.documentType: NSAttributedString.DocumentType.html],
        documentAttributes: nil
      )
    else {
      return nil
    }

    return attributedString
  }
}
