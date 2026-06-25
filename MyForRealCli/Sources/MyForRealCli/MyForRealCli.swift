// The Swift Programming Language
// https://docs.swift.org/swift-book

import MyCommandParser

let myCommandNodeNameArray = [
    "project",
    "create",
]

let myCommandNodeParentArray: [CommandNodeIndex] = [
    InvalidCommandNodeIndex,
    0,
]

func commandProjectCreate(path: Substring) {
    // Note: Acceptable path strings are either absolute paths, or relative to the cwd.
    print("Creating project at", path)
}

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

        let commandNodeFullName = getFullNameOfCommandNode(commandNodeNameArray: myCommandNodeNameArray, commandNodeParentArray: myCommandNodeParentArray, commandNode: parsedCommand.commandNodeIndex)

        switch parsedCommand.commandNodeIndex {
        case 0:
            print("error:", "'\(commandNodeFullName)'", "is not a fully specified command name")
        case 1:
            guard let pathArgument = parsedCommand.positionalArguments.first else {
                print("error: no path argument specified")
                break
            }

            // TODO: [todo] Implement validation that no additional, unrecognized arguments were given.

            commandProjectCreate(path: pathArgument)
        default:
            assert(false, "Unimplemented command index.")
        }

        // TODO: [todo] Write tests that verify intented results of these.
        print("parsedCommand.namedArguments:", parsedCommand.namedArguments)
        print("parsedCommand.flagArguments:", parsedCommand.flagArguments)
        print("parsedCommand.positionalArguments:", parsedCommand.positionalArguments)
    }
}
