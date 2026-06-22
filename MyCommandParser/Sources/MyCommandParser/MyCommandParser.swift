// The Swift Programming Language
// https://docs.swift.org/swift-book

public func myYoFunc() -> Int32 {
    return 8
}

// TODO: [todo] Change the data structure of the "functionTable" parameter, to support namespaced command names and arguments.
public func dispatchCommandToFunction(args: ArraySlice<String>, functionTable: [String: @Sendable () -> Void]) {
    if args.isEmpty
    {
        return
    }

    if let foundFunction = functionTable[args.first!] {
        foundFunction()
    }
}
