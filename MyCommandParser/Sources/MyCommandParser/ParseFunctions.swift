
public func isCommandNodeChildOf(commandNodeParentArray: [CommandNodeIndex], commandNode: CommandNodeIndex, parentNode: CommandNodeIndex) -> Bool {
    let actualParentNode = commandNodeParentArray[commandNode]
    return parentNode == actualParentNode
}

public func parseCommandNodeIndex(tokens: ArraySlice<String>, commandNodeNameArray: [String], commandNodeParentArray: [CommandNodeIndex]) -> CommandNodeIndex? {
    var commandNodeIndex: CommandNodeIndex? = nil

    for token in tokens {
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

        commandNodeIndex = currentTokenCommandNodeIndex
    }

    return commandNodeIndex
}

// TODO: [todo] Implement arguments.
public func parseCommand(tokens: ArraySlice<String>, commandNodeNameArray: [String], commandNodeParentArray: [CommandNodeIndex]) -> ParsedCommand? {
    if tokens.isEmpty
    {
        return nil
    }

    guard let commandNodeIndex = parseCommandNodeIndex(tokens: tokens, commandNodeNameArray: commandNodeNameArray, commandNodeParentArray: commandNodeParentArray) else {
        // No command node found for the tokens passed in.
        return nil
    }

    return ParsedCommand(commandNodeIndex: commandNodeIndex)
}
