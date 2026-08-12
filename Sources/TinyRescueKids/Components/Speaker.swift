import AVFoundation

/// 中文语音引导：3-4岁儿童不识字，所有玩法说明都用语音播报。
/// 使用系统 AVSpeechSynthesizer，离线可用，无需任何资源文件。
final class Speaker {
    static let shared = Speaker()

    private let synthesizer = AVSpeechSynthesizer()

    private init() {}

    /// 朗读文本（自动打断上一句，语速放慢适合幼儿）
    func speak(_ text: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")
        utterance.rate = 0.42      // 默认0.5，放慢一点幼儿更容易听清
        utterance.pitchMultiplier = 1.15 // 音调稍高，更亲切
        synthesizer.speak(utterance)
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}
