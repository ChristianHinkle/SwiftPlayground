
// TODO: [todo] Implement namespaced command names and implement arguments.
public func parseCommand(args: ArraySlice<String>, commandNames: [String]) -> ParsedCommand? {
    if args.isEmpty
    {
        return nil
    }

    let commandName = args.first!

    guard let foundCommandIndex = commandNames.firstIndex(of: commandName) else {
        return nil
    }

    return ParsedCommand(commandIndex: foundCommandIndex)
}
