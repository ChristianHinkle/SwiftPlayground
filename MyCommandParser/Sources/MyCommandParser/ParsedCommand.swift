
// We want this to simply be an index type. See https://developer.apple.com/documentation/swift/array/index.
public typealias CommandNodeIndex = Int

public let InvalidCommandNodeIndex: CommandNodeIndex = -1

public struct ParsedCommand {
    public var namedArguments: [Substring: Substring] = [:]
    public var flagArguments: Set<Substring> = []
    public var positionalArguments: [Substring] = []
    public var commandNodeIndex: CommandNodeIndex
}
