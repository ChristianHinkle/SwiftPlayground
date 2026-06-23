
// We want this to simply be an index type. See https://developer.apple.com/documentation/swift/array/index.
public typealias CommandNodeIndex = Int

public let InvalidCommandNodeIndex: CommandNodeIndex = -1

public struct ParsedCommand {
    public var commandNodeIndex: CommandNodeIndex

    // TODO: [todo] Add members for named arguments, positional arguments, and flags.
}
