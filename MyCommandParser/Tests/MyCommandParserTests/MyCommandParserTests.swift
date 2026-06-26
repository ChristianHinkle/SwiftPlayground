import Testing
@testable import MyCommandParser

let myCommandNodeNameArray = [
    "project",
    "create",
]

let myCommandNodeParentArray: [CommandNodeIndex] = [
    InvalidCommandNodeIndex,
    0,
]

@Test func testParseCommand() async throws {
    let tokens = ["project", "create", "dfads", "--hey", "adio2", "--yo=3", "as"]

    let parsedCommand = parseCommand(tokens: tokens[...], commandNodeNameArray: myCommandNodeNameArray, commandNodeParentArray: myCommandNodeParentArray)
    #expect(parsedCommand != nil)
    guard let parsedCommand else {
        return
    }

    #expect(parsedCommand.commandNodeIndex == 1)

    #expect(parsedCommand.namedArguments["yo"] != nil)
    #expect(parsedCommand.namedArguments["yo"]! == "3")

    #expect(parsedCommand.flagArguments.contains("hey"))

    #expect(parsedCommand.positionalArguments.contains("dfads"))
    #expect(parsedCommand.positionalArguments.contains("adio2"))
    #expect(parsedCommand.positionalArguments.contains("as"))
}

@Test func testGetFullNameOfCommandNode() async throws {
    let commandNodeFullName = getFullNameOfCommandNode(1, commandNodeNameArray: myCommandNodeNameArray, commandNodeParentArray: myCommandNodeParentArray)
    #expect(commandNodeFullName == "project create")
}
