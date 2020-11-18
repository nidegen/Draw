import Foundation
import ArgumentParser

struct Draw: ParsableCommand {
  
  @Flag(name: .shortAndLong, help: "Override existing PNGs")
  var override = false
  
  @Option(name: .shortAndLong, help: "The path to the draw tasks")
  var tasksPath: String = "./"
  
  mutating func run() throws {
    let url = URL(fileURLWithPath: tasksPath).appendingPathComponent("draw-tasks.json")
    print("Processing Tasks from \(url.path)")
    if let tasks = try? readJSONDrawTasks(url) {
      perform(tasks: tasks, forceOverride: false)
    } else {
      print("No draw-tasks.json file found or it is misformatted!")
    }
  }
}

Draw.main()


