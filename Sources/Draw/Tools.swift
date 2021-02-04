import Foundation
import Yams

func perform(tasks: [DrawTask], forceOverride: Bool, location: URL) {
  let tmpURL = URL(fileURLWithPath: "/tmp/drawcommands\(Int.random(in: 1...999))")
  shell("touch \(tmpURL.path)")
  guard let fileUpdater = try? FileHandle(forUpdating: tmpURL) else { exit(0) }
  fileUpdater.seekToEndOfFile()
  
  
  print("Prossessing \(tasks.count) tasks.")
  let inputs = tasks.map { $0.inputFile }
  print("Using input files \(inputs).")
  
  var commands = [String]()
  
  for task in tasks {
    commands += task.inkscapeCommands(forceOverride: forceOverride, relativeTo: location)
  }
  if commands.isEmpty {
    print("No tasks found to do. Terminating..")
    return
  }
  
  commands.forEach {
    //    shell("echo \($0) >> /Users/nicolas/Desktop/commands.txt")
    fileUpdater.write("\($0)\n".data(using: .utf8)!)
  }
  
  _ = checkForValidInkscapeVersion()
  
  fileUpdater.write("quit".data(using: .utf8)!)
  fileUpdater.closeFile()
  
  shell("inkscape --shell < \(tmpURL.path)")
  shell("rm -f  \(tmpURL.path)")
  print("Performing conversion tasks on inkscape (\(commands.count) commands)")
  print("Finished successfully")
}


func encodeYaml(_ task: DrawTask) throws -> String {
  let encoder = YAMLEncoder()
  return try encoder.encode(task)
}

func encodeJSON(_ task: DrawTask) throws -> Data {
  let encoder = JSONEncoder()
  return try encoder.encode(task)
}

func encodeJSON(_ tasks: [DrawTask]) throws -> Data {
  let encoder = JSONEncoder()
  return try encoder.encode(tasks)
}

func  readYAMLDrawTasks(_ url: URL) throws -> [DrawTask] {
  let yamlData = try Data(contentsOf: url).base64EncodedString()
  let decoder = YAMLDecoder()
  let decoded = try decoder.decode([DrawTask].self, from: yamlData)
  return decoded
}

func readJSONDrawTasks(_ url: URL) throws -> [DrawTask] {
  let encodedJSON = try Data(contentsOf: url)
  let decoder = JSONDecoder()
  let decoded = try decoder.decode([DrawTask].self, from: encodedJSON)
  return decoded
}

extension URL    {
  var fileExists: Bool {
    FileManager.default.fileExists(atPath: self.path)
  }
}
