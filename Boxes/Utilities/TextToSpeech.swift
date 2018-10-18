//
//  TextToSpeech.swift
//  Boxes
//
//  Created by Bryan Hathaway on 3/10/18.
//  Copyright © 2018 Bryan Hathaway. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class TextToSpeech: NSObject {
    static let shared = TextToSpeech()

    private let synthesizer = AVSpeechSynthesizer()
    private let audioSession = AVAudioSession.sharedInstance()

    private var onFinish: (() -> ())?

    var isSpeaking: Bool {
        return synthesizer.isSpeaking
    }

    override init() {
        super.init()

        synthesizer.delegate = self
    }

    private lazy var voice: AVSpeechSynthesisVoice? = {
        let enhancedVoices = AVSpeechSynthesisVoice.speechVoices().filter { $0.quality == .enhanced }

        guard enhancedVoices.count > 0 else {
            guard let language = NSLocale.preferredLanguages.first else { return nil }
            return AVSpeechSynthesisVoice(language: language)
        }

        // Siri voices are best quality, use if found
        if let siriVoice = enhancedVoices.first(where: { $0.identifier.contains("siri") }) {
            return siriVoice
        } else {
            return enhancedVoices.first
        }
    }()

    /// Speaks the given text. If there is already speech active, it will finish before this call begins.
    func speak(text: String, completion: (() ->())? = nil) {
        guard let voice = voice else {
            completion?()
            return
        }
        onFinish = completion
        speak(text: text, using: voice)
    }

    func stop() {
        synthesizer.stopSpeaking(at: .immediate)
        finalise()
    }

    private func speak(text: String, using voice: AVSpeechSynthesisVoice) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = voice
        utterance.rate = 0.5

        try? audioSession.setCategory(AVAudioSession.Category.playback,
                                      mode: AVAudioSession.Mode.default,
                                      options: AVAudioSession.CategoryOptions.mixWithOthers)
        try? audioSession.setActive(true, options: [])
        synthesizer.speak(utterance)
    }

    private func finalise() {
        onFinish?()
        onFinish = nil
        try? audioSession.setActive(false, options: [])
    }
}

extension TextToSpeech: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        finalise()
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        finalise()
    }
}
