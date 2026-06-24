
public func isCommandNodeChildOf(commandNodeParentArray: [CommandNodeIndex], commandNode: CommandNodeIndex, parentNode: CommandNodeIndex) -> Bool {
    let actualParentNode = commandNodeParentArray[commandNode]
    return parentNode == actualParentNode
}

public struct ParsedCommandNodeIndexResult {
    public var result: Int
    public var numTokensParsed: Int
}

public func parseCommandNodeIndex(tokens: ArraySlice<String>, commandNodeNameArray: [String], commandNodeParentArray: [CommandNodeIndex]) -> ParsedCommandNodeIndexResult? {
    var commandNodeIndex: CommandNodeIndex? = nil

    var numTokensParsed: Int = 0

    for token in tokens {
        // TODO: [todo] Handle duplicate child command node names that have different parents.
        guard let currentTokenCommandNodeIndex = commandNodeNameArray.firstIndex(of: token) else {
            // This token is not a command node.
            break
        }

        if let previousTokenCommandNodeIndex = commandNodeIndex {
            if !isCommandNodeChildOf(commandNodeParentArray: commandNodeParentArray, commandNode: currentTokenCommandNodeIndex, parentNode: previousTokenCommandNodeIndex) {
                // This token is not a child command node of the previous token.
                break
            }
        }

        numTokensParsed += 1
        commandNodeIndex = currentTokenCommandNodeIndex
    }

    guard let commandNodeIndex else {
        return nil
    }

    return ParsedCommandNodeIndexResult(result: commandNodeIndex, numTokensParsed: numTokensParsed)
}

public struct ParsedCommandArgumentsResult {
    public var namedArguments: [String: String] = [:]
    public var flagArguments: Set<String> = []
    public var positionalArguments: [String] = []
}

public func parseCommandArguments(argumentTokens: ArraySlice<String>) -> ParsedCommandArgumentsResult {

    var namedArguments: [String: String] = [:]
    var flagArguments: Set<String> = []
    var positionalArguments: [String] = []

    for token in argumentTokens {
        // TODO: [todo] Populate the argument variables that will be returned.
    }

    return ParsedCommandArgumentsResult(namedArguments: namedArguments, flagArguments: flagArguments, positionalArguments: positionalArguments)
}

public func parseCommand(tokens: ArraySlice<String>, commandNodeNameArray: [String], commandNodeParentArray: [CommandNodeIndex]) -> ParsedCommand? {
    if tokens.isEmpty
    {
        return nil
    }

    guard let parsedCommandNodeIndexResult = parseCommandNodeIndex(tokens: tokens, commandNodeNameArray: commandNodeNameArray, commandNodeParentArray: commandNodeParentArray) else {
        // No command node found for the tokens passed in.
        return nil
    }

    let argumentTokens = tokens.suffix(from: tokens.startIndex + parsedCommandNodeIndexResult.numTokensParsed)

    let parsedCommandArgumentsResult = parseCommandArguments(argumentTokens: argumentTokens)

    return ParsedCommand(
        namedArguments: parsedCommandArgumentsResult.namedArguments,
        flagArguments: parsedCommandArgumentsResult.flagArguments,
        positionalArguments: parsedCommandArgumentsResult.positionalArguments,
        commandNodeIndex: parsedCommandNodeIndexResult.result)
}
