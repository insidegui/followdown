import Foundation
import ShellOut

// Delete FollowUp DB
_ = try? shellOut(to: "/bin/rm", arguments: ["~/Library/CoreFollowUp/items.db"])

// Restart FollowUp daemon
_ = try? shellOut(to: "/usr/bin/killall", arguments: ["followupd"])

// Remove badge from within System Preferences
_ = try? shellOut(to: "/usr/bin/defaults", arguments: ["delete", "com.apple.systempreferences", "AttentionPrefBundleIDs"])

let dockPrefsPath = NSHomeDirectory() + "/Library/Preferences/com.apple.dock.plist"

if let dockPrefs = NSMutableDictionary(contentsOfFile: dockPrefsPath), var apps = dockPrefs["persistent-apps"] as? [NSDictionary] {
    if let prefsIdx = apps.firstIndex(where: { ($0["tile-data"] as? NSDictionary)?["file-label"] as? String == "System Preferences" }) {
        let prefsDict = apps[prefsIdx].mutableCopy() as! NSMutableDictionary
        let tileData = (prefsDict["tile-data"] as! NSDictionary).mutableCopy() as! NSMutableDictionary
        tileData["dock-extra"] = 0
        prefsDict["tile-data"] = tileData
        apps[prefsIdx] = prefsDict
        dockPrefs["persistent-apps"] = apps
        _ = dockPrefs.write(toFile: dockPrefsPath, atomically: true)
    }
}

// Restart Dock and cfprefsd
_ = try? shellOut(to: "/usr/bin/killall", arguments: ["cfprefsd"])
_ = try? shellOut(to: "/usr/bin/killall", arguments: ["Dock"])

print("👵🏼 This house is now clean!")
