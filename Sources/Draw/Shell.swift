import Foundation

@discardableResult func shell(_ command: String) -> (String?, Int32) {
  let task = Process()
  
  task.launchPath = "/bin/bash"
  task.arguments = ["-c", command]
  
  let pipe = Pipe()
  task.standardOutput = pipe
  task.standardError = pipe
  task.launch()
  
  let data = pipe.fileHandleForReading.readDataToEndOfFile()
  let output = String(data: data, encoding: .utf8)
  task.waitUntilExit()
  return (output, task.terminationStatus)
}

func detectValidInkscapeVersion() -> Bool {
  let (output, _) = shell("inkscape --version")
  guard var version = output else { return false }
  version = String(version.dropFirst(9).split(separator: "(").first ?? "")
  version = version.replacingOccurrences(of: " ", with: "")
  print("Found Inkscape version \(version)")
  let minimumVersion = "1.0.1"

  if version == "" {
    print("Please install Inkscape 1.0.1")
    return false
  }
  
  let result = version.compare(minimumVersion, options: .numeric)
  switch result {
  case .orderedSame :
    return true
  case .orderedAscending :
    print("Unsupported Inkscape: Minimum supported Version is version \(minimumVersion)")
    return false
  case .orderedDescending :
    return true
  }
}
