// The Swift Programming Language
// https://docs.swift.org/swift-book

import MyCommandParser

func commandProjectCreate(path: String) {
    print("Creating project at", path)
}

func commandProjectCreateNoParamsJustForExperimenting() {
    commandProjectCreate(path: "This is a fake placeholder string")
}

let myCommandNodeNameArray = [
    "project",
    "create",
]

let myCommandNodeParentArray: [CommandNodeIndex] = [
    InvalidCommandNodeIndex,
    0,
]

@main
struct MyForRealCli {
    static func main() {
        print("Hello, world!")

        // Note: As a CLI application, we ignore the first arg, as that is conventionally the program name, but it's not guarenteed to
        // be anyway, and we don't need it anyway.

        guard let parsedCommand = parseCommand(tokens: CommandLine.arguments.dropFirst(), commandNodeNameArray: myCommandNodeNameArray, commandNodeParentArray: myCommandNodeParentArray) else {
            print("Invalid command name")
            return
        }

        switch parsedCommand.commandNodeIndex {
        case 0:
            assert(false, "TODO: [todo] Handle case when user tries to execute a namespacing command node like this one which is not executable.")
        case 1:
            commandProjectCreateNoParamsJustForExperimenting()
        default:
            assert(false, "Unimplemented command index.")
        }

        // TODO: [todo] Write tests that verify intented results of these.
        print("parsedCommand.namedArguments:", parsedCommand.namedArguments)
        print("parsedCommand.flagArguments:", parsedCommand.flagArguments)
        print("parsedCommand.positionalArguments:", parsedCommand.positionalArguments)
    }
}
