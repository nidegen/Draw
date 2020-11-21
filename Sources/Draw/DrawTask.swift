import Foundation

struct DrawTask: Codable {
  var inputFile: String
  var outputDir: String
  var outputFilename: String
  var scaledResolutions: [Resolution]
  struct Resolution: Codable {
    var pixels: Float
    var scales: [Int]
    
    func commands(location: URL, inputFile: String, outputDir: String, outputFilename: String, forceOverride: Bool) -> [String] {
      scales.compactMap { scale in
        let scaleExtension = (scale != 1) ? "@\(scale)x" : ""
        
        var destination: URL = (outputDir.first == ".") ? location.appendingPathComponent(outputDir) : URL(fileURLWithPath: outputDir)
        destination.appendPathComponent(outputFilename + "\(pixels)" + scaleExtension)
        destination.appendPathExtension("png")
        
        let inputURL = (inputFile.first == ".") ? location.appendingPathComponent(inputFile) : URL(fileURLWithPath: inputFile)
        
        if forceOverride || !FileManager.default.fileExists(atPath: destination.path)  {
          return "file-open:\(inputURL.path); export-filename:\(destination.path); export-width:\(pixels * Float(scale)); export-do"
        } else {
          return nil
        }
      }
    }
  }
}

extension DrawTask {
  static var testA = DrawTask(inputFile: "./Test.svg", outputDir: "../Output", outputFilename: "TestA", scaledResolutions: [Resolution(pixels: 23.5, scales: [1])])
  static var testB = DrawTask(inputFile: "./Tester.svg", outputDir: "../Output", outputFilename: "TestB", scaledResolutions: [Resolution(pixels: 33.5, scales: [1]), Resolution(pixels: 234, scales: [])])
  
  
  static var test =
    [
      DrawTask(
        inputFile:"./Resources/Icons/AppIcon.svg",
        outputDir:"./Resources/Assets.xcassets/AppIcon.appiconset",
        outputFilename:"AppIcon",
        scaledResolutions: [
          DrawTask.Resolution(pixels: 20, scales: [1,2,3]),
          DrawTask.Resolution(pixels: 29, scales: [1,2,3]),
          DrawTask.Resolution(pixels: 40, scales: [1,2,3]),
          DrawTask.Resolution(pixels: 60, scales: [2,3]),
          DrawTask.Resolution(pixels: 76, scales: [1,2]),
          DrawTask.Resolution(pixels: 83.5, scales: [2]),
          DrawTask.Resolution(pixels: 1024, scales: [1]),
        ]
      ),
      DrawTask(
        inputFile:"./Resources/Icons/CrosshairRed.svg",
        outputDir:"./Resources/Assets.xcassets/CrosshairRed.appiconset",
        outputFilename:"CrosshairRed",
        scaledResolutions: [DrawTask.Resolution(pixels: 100, scales: [1,2,3])]
      ),
      DrawTask(
        inputFile: "./Resources/Icons/RainbowAppIcon.svg",
        outputDir: ".Resources/AlternateAppIcons",
        outputFilename: "RainbowAppIcon",
        scaledResolutions: [DrawTask.Resolution(pixels: 60, scales: [2,3])]
      ),
      DrawTask(
        inputFile: "./Resources/Icons/RedWhiteAppIcon.svg",
        outputDir: ".Resources/AlternateAppIcons",
        outputFilename: "RedWhiteAppIcon",
        scaledResolutions: [DrawTask.Resolution(pixels: 60, scales: [2,3])]
      ),
      DrawTask(
        inputFile: "./Resources/Icons/BlackWhiteAppIcon.svg",
        outputDir: ".Resources/AlternateAppIcons",
        outputFilename: "BlackWhiteAppIcon",
        scaledResolutions: [DrawTask.Resolution(pixels: 60, scales: [2,3])]
      ),
      DrawTask(
        inputFile: "./Resources/Icons/WhiteBlackAppIcon.svg",
        outputDir: ".Resources/AlternateAppIcons",
        outputFilename: "WhiteBlackAppIcon",
        scaledResolutions: [DrawTask.Resolution(pixels: 60, scales: [2,3])]
      ),
      DrawTask(
        inputFile: "./Resources/Icons/TableIconDeveloper.svg",
        outputDir: ".Resources/Assets.xcassets/TableIconDeveloper.imageset",
        outputFilename: "TableIconDeveloper",
        scaledResolutions: [DrawTask.Resolution(pixels: 30, scales: [1, 2, 3])]
      ),
    ]

  
  func inkscapeCommands(forceOverride: Bool = false, relativeTo location: URL) -> [String] {
    scaledResolutions.flatMap { (resolution: Resolution) in
      resolution.commands(location: location, inputFile: inputFile, outputDir: outputDir, outputFilename: outputFilename, forceOverride: forceOverride)
    }
  }
}
