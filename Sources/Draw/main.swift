import Foundation
import ArgumentParser

struct Draw: ParsableCommand {
  
  @Flag(name: .shortAndLong, help: "Override existing PNGs")
  var override = false
  
  @Option(name: .shortAndLong, help: "The path to the draw tasks")
  var tasksPath: String = "./"
  
  mutating func run() throws {
    let location = URL(fileURLWithPath: tasksPath)
    
    let json = location.appendingPathComponent("draw-tasks.json")
    let yaml = location.appendingPathComponent("draw-tasks.yaml")
    
    if json.fileExists {
      print("Prossessing draw task JSON file at \(json.path)")
      do {
        let tasks = try readJSONDrawTasks(json)
        perform(tasks: tasks, forceOverride: false, location: location)
      } catch {
        print(error.localizedDescription)
      }
    } else if yaml.fileExists {
      print("Prossessing draw task YAML file at \(yaml.path)")
      do {
        let tasks = try readYAMLDrawTasks(json)
        perform(tasks: tasks, forceOverride: false, location: location)
      } catch {
        print(error.localizedDescription)
      }
    } else {
      print("No draw-tasks.json or yaml file found!")
    }
  }
}

Draw.main()
