import Foundation

fileprivate let cachedKey = "InkscapeVersionCached"

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

func readInkscapeVersionString() -> String? {
  let (output, _) = shell("inkscape --version")
  guard var versionString = output else { return nil }
  versionString = String(versionString.dropFirst(9).split(separator: "(").first ?? "")
  versionString = versionString.replacingOccurrences(of: " ", with: "")
  UserDefaults.standard.set(versionString, forKey: cachedKey)
  return versionString
}

func checkForValidInkscapeVersion() -> Bool {
  guard let version = UserDefaults.standard.string(forKey: cachedKey) ?? readInkscapeVersionString() else { return false }
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
