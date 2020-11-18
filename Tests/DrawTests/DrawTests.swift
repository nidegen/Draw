import XCTest
import class Foundation.Bundle
//import Draw

final class DrawTests: XCTestCase {
  func testExample() throws {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    
    // Some of the APIs that we use below are available in macOS 10.13 and above.
    guard #available(macOS 10.13, *) else {
      return
    }

//    let taskA = DrawTask(inputFile: "testA", outputDir: "testADir", outputFilename: "testAFilename", scaledResolutions: [100: [1,2,3], 12:[]])
//    
//    let taskB = DrawTask(inputFile: "testB", outputDir: "testBDir", outputFilename: "testBFilename", scaledResolutions: [22: [1,2,3], 12:[2,3]])
//    
//    var tasks = [taskA, taskB]
//    
//    Draw.perform(tasks: tasks, forceOverride: true)
//    print("Test")
    
    let fooBinary = productsDirectory.appendingPathComponent("Draw")
    
    let process = Process()
    process.executableURL = fooBinary
    
    let pipe = Pipe()
    process.standardOutput = pipe
    
    try process.run()
    process.waitUntilExit()
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)
    
    XCTAssertEqual(output, "Hello, world!\n")
  }
  
  /// Returns path to the built products directory.
  var productsDirectory: URL {
    #if os(macOS)
    for bundle in Bundle.allBundles where bundle.bundlePath.hasSuffix(".xctest") {
      return bundle.bundleURL.deletingLastPathComponent()
    }
    fatalError("couldn't find the products directory")
    #else
    return Bundle.main.bundleURL
    #endif
  }
  
  static var allTests = [
    ("testExample", testExample),
  ]
}
