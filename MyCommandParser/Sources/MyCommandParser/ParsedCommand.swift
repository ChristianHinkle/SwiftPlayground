
// We want this to simply be an index type. See https://developer.apple.com/documentation/swift/array/index.
public typealias CommandIndex = Int

public struct ParsedCommand {
    public var commandIndex: CommandIndex

    // TODO: [todo] Add members for named arguments, positional arguments, and flags.
}
