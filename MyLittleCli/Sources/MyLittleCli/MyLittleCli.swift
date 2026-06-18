// The Swift Programming Language
// https://docs.swift.org/swift-book

@main
struct MyLittleCli {
    static func main() {
        print("Hello, world!")

        print()

        // Note: As a CLI application, we ignore the first arg, as that is conventionally the program name, but it's not guarenteed to
        // be anyway, and we don't need it anyway.

        if (CommandLine.arguments.count <= 1) {
            print("You gave me no args.")
            return
        }

        print("I have your args:")
        print()

        // Note: No allocations here. `String` is copy-on-write, and `dropFirst` returns an `ArraySlice` which is simply a span/view.
        for arg in CommandLine.arguments.dropFirst() {
            print(arg)
        }
    }
}
