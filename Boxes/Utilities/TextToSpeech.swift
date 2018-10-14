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

    func speak(text: String, completion: (() ->())? = nil) {
        let availableVoices = AVSpeechSynthesisVoice.speechVoices().filter { $0.quality == .enhanced }
        onFinish = completion
        guard availableVoices.count > 0 else {
            // Failsafe, play using locale
            guard let language = NSLocale.preferredLanguages.first else { return }
            guard let voice = AVSpeechSynthesisVoice(language: language) else { return }
            speak(text: text, using: voice)

            return
        }

        if let siriVoice = availableVoices.first(where: { $0.identifier.contains("siri") }) {
            speak(text: text, using: siriVoice)
        } else {
            guard let firstVoice = availableVoices.first else { return }
            speak(text: text, using: firstVoice)
        }
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
                                      options: AVAudioSession.CategoryOptions.duckOthers)
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
