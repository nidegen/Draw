import Foundation

struct DrawTask: Codable {
  var inputFile: String
  var outputDir: String
  var outputFilename: String
  var scaledResolutions: [Int: [Int]]
}

extension DrawTask {
  func inkscapeCommands(forceOverride: Bool = false) -> [String] {
    scaledResolutions.flatMap { resolution, scales in
      scales.compactMap {
        let scaleExtension = ($0 != 1) ? "@\($0)x" : ""
        let destination =
         URL(fileURLWithPath: outputDir)
          .appendingPathComponent(outputFilename + "\(resolution)" + scaleExtension)
          .appendingPathExtension("png")
        
        if forceOverride || !FileManager.default.fileExists(atPath: destination.path)  {
          return "file-open:\(URL(fileURLWithPath: inputFile).path); export-filename:\(destination.path); export-width:\(resolution * $0); export-do"
        } else {
          return nil
        }
      }
    }
  }
}
