import Foundation

enum HookInstaller {
    struct InstallError: LocalizedError {
        let message: String
        var errorDescription: String? { message }
    }

    static func run(remove: Bool = false) throws -> String {
        let home = FileManager.default.homeDirectoryForCurrentUser
        let zshrcURL = home.appendingPathComponent(".zshrc")
        
        var content = ""
        if FileManager.default.fileExists(atPath: zshrcURL.path) {
            content = try String(contentsOf: zshrcURL, encoding: .utf8)
        }
        
        let hookStart = "\n# --- BEGIN ANTIGRAVITY CAPSLOCK HOOK ---\n"
        let hookEnd = "# --- END ANTIGRAVITY CAPSLOCK HOOK ---\n"
        
        // Remove existing hook if present
        if let startRange = content.range(of: hookStart),
           let endRange = content.range(of: hookEnd, options: [], range: startRange.upperBound..<content.endIndex) {
            content.removeSubrange(startRange.lowerBound..<endRange.upperBound)
        }
        
        if remove {
            try content.write(to: zshrcURL, atomically: true, encoding: .utf8)
            return "Removed Antigravity CapsLockLED hooks from ~/.zshrc.\n\nRestart your terminal for this to take effect."
        }
        
        let bundlePath = Bundle.main.bundlePath
        if bundlePath.contains(" ") {
            throw InstallError(message: "CapsLockLED is installed in a folder whose path contains spaces:\n\n\(bundlePath)\n\nMove it to /Applications and try again.")
        }
        
        let capsSignal = bundlePath + "/Contents/MacOS/caps-signal"
        
        let hookScript = """
        \(hookStart)agy() {
            "\(capsSignal)" active
            command agy "$@"
            "\(capsSignal)" done
        }
        \(hookEnd)
        """
        
        content.append(hookScript)
        try content.write(to: zshrcURL, atomically: true, encoding: .utf8)
        
        return "Antigravity hooks installed in ~/.zshrc.\n\n• agy running → LED slow-blinks\n• agy finished → LED double-flashes\n\nStart a NEW Terminal tab for the hooks to take effect."
    }
}
