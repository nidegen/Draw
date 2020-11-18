import Foundation
import ArgumentParser

struct Draw: ParsableCommand {
  
  @Flag(name: .shortAndLong, help: "Override existing PNGs")
  var override = false
  
  @Option(name: .shortAndLong, help: "The path to the draw tasks")
  var tasksPath: String = "./"
  
  mutating func run() throws {
    let url = URL(fileURLWithPath: tasksPath)
      
    let json = url.appendingPathComponent("draw-tasks.json")
    let yaml = url.appendingPathComponent("draw-tasks.yaml")
    
    if json.fileExists {
      if let tasks = try? readJSONDrawTasks(json) {
        perform(tasks: tasks, forceOverride: false)
      } else {
        print("Error: draw-tasks.json is misformatted!")
      }
    } else if yaml.fileExists {
        if let tasks = try? readYAMLDrawTasks(yaml) {
          perform(tasks: tasks, forceOverride: false)
        } else {
          print("Error: draw-tasks.yaml is misformatted!")
        }
    } else {
      print("No draw-tasks.json or yaml file found!")
    }
  }
}

Draw.main()


