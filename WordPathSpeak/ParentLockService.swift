//
//  ParentLockService.swift
//  WordPathSpeak
//

import Foundation

class ParentLockService: ObservableObject {
    @Published private(set) var isUnlocked: Bool = false
    private var passcode: String = "1234"

    func unlock(with input: String) -> Bool {
        if input == passcode {
            isUnlocked = true
            return true
        }
        return false
    }

    func lock() {
        isUnlocked = false
    }

    func updatePasscode(_ newCode: String) {
        passcode = newCode
    }
}
