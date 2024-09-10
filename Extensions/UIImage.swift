//
//  File.swift
//  
//
//  Created by Timon Harz on 13.02.24.
//

import Foundation
import UIKit
import CoreGraphics
import Vision


extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }

    func image(byDrawingImage image: UIImage, inRect rect: CGRect) -> UIImage! {
        UIGraphicsBeginImageContext(size)

        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        image.draw(in: rect)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }

    func resize(newSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
  public func fit(in size: CGSize, background: UIColor = UIColor.black) -> UIImage? {
      let rect = CGRect(origin: .zero, size: size)
      var scaledImageRect = CGRect.zero

      let aspectWidth: CGFloat = size.width / self.size.width
      let aspectHeight: CGFloat = size.height / self.size.height
      let aspectRatio: CGFloat = max(aspectWidth, aspectHeight)

      scaledImageRect.size.width = self.size.width * aspectRatio
      scaledImageRect.size.height = self.size.height * aspectRatio
      scaledImageRect.origin.x = (size.width - scaledImageRect.size.width) / 2.0
      scaledImageRect.origin.y = (size.height - scaledImageRect.size.height) / 2.0

      UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
      guard let context = UIGraphicsGetCurrentContext() else {
          return nil
      }

      // Fill background
      context.setFillColor(background.cgColor)
      context.fill(rect)

      // Draw image
      self.draw(in: scaledImageRect)

      // Get scaled image
      guard let scaledImage = UIGraphicsGetImageFromCurrentImageContext() else {
          UIGraphicsEndImageContext()
          return nil
      }

      UIGraphicsEndImageContext()
      return scaledImage
  }

func invert() -> UIImage {
   let beginImage = CIImage(image: self)
   if let filter = CIFilter(name: "CIColorInvert") {
       filter.setValue(beginImage, forKey: kCIInputImageKey)
       return UIImage(ciImage: filter.outputImage!)
   }
   return self
}
  func withBackgroundColor(_ color: UIColor, size: CGSize) -> UIImage {
          UIGraphicsBeginImageContextWithOptions(size, false, scale)
          color.setFill()
          UIBezierPath(rect: CGRect(origin: .zero, size: size)).fill()
          draw(in: CGRect(origin: CGPoint(x: (size.width - self.size.width) / 2, y: (size.height - self.size.height) / 2), size: self.size))
          let imageWithBackground = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
          return imageWithBackground ?? UIImage()
      }

    func toPixelData() -> [UInt8]? {
        let dataSize = size.width * size.height * 4
        var pixelData = [UInt8](repeating: 0, count: Int(dataSize))
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: &pixelData, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 4 * Int(size.width), space: colorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)

        guard let cgImage = self.cgImage else {return nil}
        context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))

        return pixelData
    }

    func toMLMultiArray() -> MLMultiArray? {
        guard let pixelData = toPixelData()?.map({
            Double($0) / 255.0
        }) else {return nil}


        guard let array = try? MLMultiArray(
            shape: [1, NSNumber(value: Int(size.width)), NSNumber(value: Int(size.height))],
            dataType: .double) else {return nil}

        let r = pixelData.enumerated().filter { $0.offset % 4 == 0 }.map { $0.element }
        let g = pixelData.enumerated().filter { $0.offset % 4 == 1 }.map { $0.element }
        let b = pixelData.enumerated().filter { $0.offset % 4 == 2 }.map { $0.element }

        for index in 0..<r.count {
            let element = NSNumber(value: 0.2126 * r[index] + 0.7152 * g[index] + 0.0722 * b[index])
            array[index] = element
        }

        return array
    }

  func toCVPixelBuffer() -> CVPixelBuffer? {
         var pixelBuffer: CVPixelBuffer? = nil
  let attr = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue,
          kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary

         let width = Int(self.size.width)
         let height = Int(self.size.height)
  CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_OneComponent8, attr, &pixelBuffer)
         CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue:0))
  let colorspace = CGColorSpaceCreateDeviceGray()
         let bitmapContext = CGContext(data: CVPixelBufferGetBaseAddress(pixelBuffer!), width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: colorspace, bitmapInfo: 0)!
  guard let cg = self.cgImage else {
             return nil
         }
  bitmapContext.draw(cg, in: CGRect(x: 0, y: 0, width: width, height: height))
  return pixelBuffer
      }
  func centered(in rect: CGRect) -> UIImage {
          let imageSize = self.size
          let targetRect = CGRect(x: (rect.size.width - imageSize.width) / 2.0,
                                   y: (rect.size.height - imageSize.height) / 2.0,
                                   width: imageSize.width,
                                   height: imageSize.height)

          UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)

          self.draw(in: CGRect(origin: .zero, size: rect.size))

          let newImage = UIGraphicsGetImageFromCurrentImageContext()

          UIGraphicsEndImageContext()

          return newImage ?? self
      }
  func zoomOut(by scale: CGFloat) -> UIImage? {
          let newSize = CGSize(width: self.size.width * scale, height: self.size.height * scale)

          UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
          defer { UIGraphicsEndImageContext() }

          self.draw(in: CGRect(origin: .zero, size: newSize))

          guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
              return nil
          }

          return newImage
      }
}


extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}
