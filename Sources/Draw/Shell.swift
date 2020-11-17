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
