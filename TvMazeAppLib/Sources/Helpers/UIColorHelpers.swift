import UIKit

extension UIColor {
  var hex: UInt {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    if !getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
      getWhite(&red, alpha: &alpha)
      green = red
      blue = red
    }

    red = round(red * 255)
    green = round(green * 255)
    blue = round(blue * 255)
    alpha = round(alpha * 255)

    return UInt(alpha) << 24 | UInt(red) << 16 | UInt(green) << 8 | UInt(blue)
  }

  var hexString: String {
    String(format: "0x%08x", hex)
  }

  public var cssString: String {
    let hex = self.hex
    if hex & 0xFF00_0000 == 0xFF00_0000 {
      return String(format: "#%06x", hex & 0xFFFFFF)
    }

    return String(format: "#%08x", hex)
  }
}
