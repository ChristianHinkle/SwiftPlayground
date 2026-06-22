
public func parseCommand(args: ArraySlice<String>, commandNames: [String]) -> ParsedCommand? {
    if args.isEmpty
    {
        return nil
    }

    let commandName = args.first!

    let foundCommandIndex = commandNames.firstIndex(of: commandName)
    if foundCommandIndex == nil {
        return nil
    }

    return ParsedCommand(commandIndex: foundCommandIndex!)
}
