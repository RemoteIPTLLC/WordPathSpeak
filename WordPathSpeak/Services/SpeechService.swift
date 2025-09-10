//
//  SpeechService.swift
//  WordPathSpeak
//
//  Created by Steven Mahathirath on 9/1/25.
//
import Foundation
import AVFoundation

final class SpeechService {
    static let shared = SpeechService()
    private let synth = AVSpeechSynthesizer()
    func speak(_ text: String) {
        let u = AVSpeechUtterance(string: text)
        u.rate = 0.45
        synth.speak(u)
    }
}

