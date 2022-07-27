import Foundation
import Plot
import Publish

extension Plugin {
    static func tailwindcss(
        themeFilePath: Path,
        configFilePath: Path,
        outputFilePath: Path
    ) -> Self {
        Plugin(name: "Tailwind CSS") { context in
            let task = Process()
            let rootPath = try context.folder(at: "").path
            let themeFile = try context.file(at: themeFilePath)
            let configFile = try context.file(at: configFilePath)
            let outputFile = try context.createOutputFile(at: outputFilePath)
            let script = "cd \(rootPath) && npx tailwindcss build -i \(themeFile.path) -o \(outputFile.path) -c \(configFile.path)"
            task.launchPath = "/bin/zsh"
            task.arguments = ["-c", script]
            try task.run()
            task.waitUntilExit()
        }
    }
}
