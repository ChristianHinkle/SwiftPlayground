
// We want this to simply be an index type. See https://developer.apple.com/documentation/swift/array/index.
public typealias CommandNodeIndex = Int

public let InvalidCommandNodeIndex: CommandNodeIndex = -1

public struct ParsedCommand {
    public var namedArguments: [String: String] = [:]
    public var flagArguments: Set<String> = []
    public var positionalArguments: [String] = []
    public var commandNodeIndex: CommandNodeIndex
}
