// The Swift Programming Language
// https://docs.swift.org/swift-book

import MyCommandParser

func commandProjectCreate(path: String) {
    print("Creating project at", path)
}

func commandProjectCreateNoParamsJustForExperimenting() {
    commandProjectCreate(path: "This is a fake placeholder string")
}

let myCommandNames = [
    "projectCreate"
]

@main
struct MyForRealCli {
    static func main() {
        print("Hello, world!")

        // Note: As a CLI application, we ignore the first arg, as that is conventionally the program name, but it's not guarenteed to
        // be anyway, and we don't need it anyway.

        guard let parsedCommand = parseCommand(args: CommandLine.arguments.dropFirst(), commandNames: myCommandNames) else {
            print("Invalid command name")
            return
        }

        switch parsedCommand.commandIndex {
        case 0:
            commandProjectCreateNoParamsJustForExperimenting()
        default:
            assert(false, "Unimplemented command index.")
        }
    }
}
