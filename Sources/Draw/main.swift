import Foundation

let taskA = DrawTask(inputFile: "testA", outputDir: "testADir", outputFilename: "testAFilename", scaledResolutions: [100: [1,2,3], 12:[]])

let taskB = DrawTask(inputFile: "testB", outputDir: "testBDir", outputFilename: "testBFilename", scaledResolutions: [22: [1,2,3], 12:[2,3]])

var tasks = [taskA, taskB]

perform(tasks: tasks, forceOverride: true)
print("Test")


if let tasks = try? readJSONDrawTasks(URL(fileURLWithPath: "./draw-tasks.json")) {
  perform(tasks: tasks, forceOverride: false)
} else {
  print("No draw-tasks.json file found or it is misformatted!")
}
