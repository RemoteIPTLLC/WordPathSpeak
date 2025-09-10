//
//  AppModels.swift
//  WordPathSpeak
//
//  Created by Steven Mahathirath on 9/1/25.
//
import Foundation

struct AppSettings: Codable {
    var gridColumns: Int = 4
    var showLabels: Bool = true
    var theme: String = "Calm"
    var hasCompletedOnboarding: Bool = true
    var selectedAvatarKey: String = "buddy"
    var parentLockEnabled: Bool = false
}

struct GameProgress: Codable {
    var stars: Int = 0
    var streakDays: Int = 0
    var lastPlayDate: Date? = nil
}

struct Achievement: Identifiable, Codable, Hashable {
    let id: String
    var title: String
    var subtitle: String
    var symbol: String
    var unlocked: Bool = false
    var unlockedAt: Date? = nil
}

struct Avatar: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let symbol: String
}

