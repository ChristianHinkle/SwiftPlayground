
public func getFullNameOfCommandNode(_ commandNode: CommandNodeIndex, commandNodeNameArray: [String], commandNodeParentArray: [CommandNodeIndex]) -> String {
    var result = String()
    appendFullNameOfCommandNode(string: &result,
        commandNode,
        commandNodeNameArray: commandNodeNameArray,
        commandNodeParentArray: commandNodeParentArray)

    return result
}

public func appendFullNameOfCommandNode(string: inout String, _ commandNode: CommandNodeIndex, commandNodeNameArray: [String], commandNodeParentArray: [CommandNodeIndex]) {
    // Append parent node names first.
    do {
        let parentNodeIndex = commandNodeParentArray[commandNode]
        if parentNodeIndex != InvalidCommandNodeIndex {

            appendFullNameOfCommandNode(string: &string,
                parentNodeIndex,
                commandNodeNameArray: commandNodeNameArray,
                commandNodeParentArray: commandNodeParentArray)

            // Separate parent and child node names with a space.
            string.append(Character(" "))
        }
    }

    // Append our own node name.
    string.append(commandNodeNameArray[commandNode])
}

public func isCommandNodeChildOf(_ commandNode: CommandNodeIndex, parentNode: CommandNodeIndex, commandNodeParentArray: [CommandNodeIndex]) -> Bool {
    let actualParentNode = commandNodeParentArray[commandNode]
    return parentNode == actualParentNode
}

public struct ParsedCommandNodeIndex {
    public var result: Int
    public var numTokensParsed: Int
}

public func parseCommandNodeIndex(tokens: ArraySlice<String>, commandNodeNameArray: [String], commandNodeParentArray: [CommandNodeIndex]) -> ParsedCommandNodeIndex? {
    var commandNodeIndex: CommandNodeIndex? = nil
    var numTokensParsed = 0

    for token in tokens {
        // TODO: [todo] Handle duplicate child command node names that have different parents.
        guard let currentTokenCommandNodeIndex = commandNodeNameArray.firstIndex(of: token) else {
            // This token is not a command node.
            break
        }

        if let previousTokenCommandNodeIndex = commandNodeIndex {
            if !isCommandNodeChildOf(currentTokenCommandNodeIndex, parentNode: previousTokenCommandNodeIndex, commandNodeParentArray: commandNodeParentArray) {
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

    return ParsedCommandNodeIndex(result: commandNodeIndex, numTokensParsed: numTokensParsed)
}

public enum ParsedCommandArgument {
    case namedArgument(Dictionary<Substring, Substring>.Element)
    case flagArgument(Substring)
    case positionalArgument(Substring)
}

public func parseSingleCommandArgument(_ token: String) -> ParsedCommandArgument {
    // Handle positional argument case (token is not prefixed with a double dash).
    if !token.hasPrefix("--") {
        return .positionalArgument(Substring(token))
    }

    let postDoubleDashIndex = token.index(token.startIndex, offsetBy: 2)
    let tokenPostDoubleDash = token.suffix(from: postDoubleDashIndex)

    // Handle flag argument case (token has no equal character in it).
    guard let equalCharacterIndex = tokenPostDoubleDash.firstIndex(of: "=") else {
        return .flagArgument(tokenPostDoubleDash)
    }

    let postEqualCharacterIndex = tokenPostDoubleDash.index(after: equalCharacterIndex)

    // Handle named argument case (token contains an equal character).
    return .namedArgument(
        (tokenPostDoubleDash.prefix(upTo: equalCharacterIndex), tokenPostDoubleDash.suffix(from: postEqualCharacterIndex))
    )
}

public struct ParsedCommandArguments {
    public var named: [Substring: Substring] = [:]
    public var flags: Set<Substring> = []
    public var positionals: [Substring] = []
}

public func parseCommandArguments(argumentTokens: ArraySlice<String>) -> ParsedCommandArguments {
    var namedArguments: [Substring: Substring] = [:]
    var flagArguments: Set<Substring> = []
    var positionalArguments: [Substring] = []

    for token in argumentTokens {
        let commandArgumentEnum = parseSingleCommandArgument(token)

        switch commandArgumentEnum {
        case .namedArgument(let value):
            namedArguments[value.key] = value.value
        case .flagArgument(let value):
            flagArguments.insert(value)
        case .positionalArgument(let value):
            positionalArguments.append(value)
        }
    }

    return ParsedCommandArguments(
        named: namedArguments,
        flags: flagArguments,
        positionals: positionalArguments)
}

public func parseCommand(tokens: ArraySlice<String>, commandNodeNameArray: [String], commandNodeParentArray: [CommandNodeIndex]) -> ParsedCommand? {
    guard let parsedCommandNodeIndex = parseCommandNodeIndex(tokens: tokens, commandNodeNameArray: commandNodeNameArray, commandNodeParentArray: commandNodeParentArray) else {
        // No command node found for the tokens passed in.
        return nil
    }

    assert(!tokens.isEmpty, "We are confident that the token array is not empty since a command node was successfully found using them.")

    let argumentTokens = tokens.suffix(from: tokens.startIndex + parsedCommandNodeIndex.numTokensParsed)
    let parsedCommandArguments = parseCommandArguments(argumentTokens: argumentTokens)

    // TODO: [todo] Figure out if we can use move semantics to avoid copying the data structures for no reason here.
    return ParsedCommand(
        namedArguments: parsedCommandArguments.named,
        flagArguments: parsedCommandArguments.flags,
        positionalArguments: parsedCommandArguments.positionals,
        commandNodeIndex: parsedCommandNodeIndex.result)
}
