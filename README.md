# Draw

A simall command line tool to export pngs from svgs


## Installation

```
brew install mint
mint install nidegen/Draw
```


## Usage

Create a `draw-task.json` that looks like this:
```
[
  {
    "outputDir":"./",
    "inputFile":"./icon.svg",
    "outputFilename":"AppIcon",
    "scaledResolutions":{
      "100":[1, 2, 3],
      "12":[]
    }
  },
  {
    "outputDir":"/Users/nicolas/Desktop/Test",
    "inputFile":"./icon2.svg",
    "outputFilename":"Test",
    "scaledResolutions":{
      "12":[2, 3],
      "22":[1, 2, 3]
    }
  }
]
```

and then run 
```
draw -t "./path/to/dir/containing/drawtaskjson"

draw # when draw-tasks.json is in current directory 

```
