import AVFoundation

/// 中文语音引导：3-4岁儿童不识字，所有玩法说明都用语音播报。
/// 使用系统 AVSpeechSynthesizer，离线可用，无需任何资源文件。
final class Speaker {
    static let shared = Speaker()

    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    /// 朗读文本（自动打断上一句，语速放慢适合幼儿）
    /// - Parameters:
    ///   - pitch: 音调（1.0 基准，越高越尖，用于区分狗狗声音）
    ///   - rate: 语速（0.5 基准，越小越慢）
    func speak(_ text: String, pitch: Float = 1.15, rate: Float = 0.42) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = rate
        utterance.pitchMultiplier = pitch
        synthesizer.speak(utterance)
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}
