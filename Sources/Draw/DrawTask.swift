import Foundation

struct DrawTask: Codable {
  var inputFile: String
  var outputDir: String
  var outputFilename: String
  var scaledResolutions: [Int: [Int]]
}

extension DrawTask {
  func inkscapeCommands(forceOverride: Bool = false, relativeTo location: URL) -> [String] {
    scaledResolutions.flatMap { resolution, scales in
      scales.compactMap {
        let scaleExtension = ($0 != 1) ? "@\($0)x" : ""
        
        var destination: URL = (outputDir.first == ".") ? location.appendingPathComponent(outputDir) : URL(fileURLWithPath: outputDir)
        destination.appendPathComponent(outputFilename + "\(resolution)" + scaleExtension)
        destination.appendPathExtension("png")
        
        let inputURL = (inputFile.first == ".") ? location.appendingPathComponent(inputFile) : URL(fileURLWithPath: inputFile)
        
        if forceOverride || !FileManager.default.fileExists(atPath: destination.path)  {
          return "file-open:\(inputURL.path); export-filename:\(destination.path); export-width:\(resolution * $0); export-do"
        } else {
          return nil
        }
      }
    }
  }
}
