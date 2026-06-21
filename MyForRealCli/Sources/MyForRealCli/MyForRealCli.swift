// The Swift Programming Language
// https://docs.swift.org/swift-book

import MyCommandDispatcher

func commandProjectCreate(path: String) {
    print("Creating project at", path)
}

func commandProjectCreateNoParamsJustForExperimenting() {
    commandProjectCreate(path: "This is a fake placeholder string")
}

// TODO: [todo] Change the data structure of the "functionTable" parameter, to support namespaced command names and arguments.
let myFunctionTable: [String: @Sendable () -> Void] = [
    "projectCreate":  commandProjectCreateNoParamsJustForExperimenting
]

@main
struct MyForRealCli {
    static func main() {
        print("Hello, world!")

        // Note: As a CLI application, we ignore the first arg, as that is conventionally the program name, but it's not guarenteed to
        // be anyway, and we don't need it anyway.

        dispatchCommandToFunction(args: CommandLine.arguments.dropFirst(), functionTable: myFunctionTable)
    }
}
