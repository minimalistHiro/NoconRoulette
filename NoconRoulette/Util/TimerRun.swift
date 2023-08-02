//
//  TimerRun.swift
//  NoconRoulette
//
//  Created by 金子広樹 on 2023/08/02.
//

import SwiftUI

final class TimerRun: ObservableObject {
    static var shared: TimerRun = TimerRun()
    
    var timer = Timer()
    let sounds = Sounds()
    let setting = Setting()
    @Published var rotationAngle: CGFloat = 0               // ルーレット回転角度
    @Published var elapsedTime: Double = 0                  // 時間計測用変数
    @Published var isStartRoulette: Bool = false            // ルーレット開始の有無
    @Published var isShowResult: Bool = false               // 結果の表示有無
    var rotationAngleStopper: CGFloat = 1                   // 徐々にルーレットを停止するための回転角度
    let randomTimer: Double = Double.random(in: 2...3)      // ルーレット稼働時間ランダム変数
    
    ///　タイマーを開始
    /// - Parameters: なし
    /// - Returns: なし
    func startTime() {
        // ドラムロール音
        sounds.fileName = setting.drumRoll
        sounds.playLoopSound()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true) {
            [self] _ in
            
            // 時間計測用変数が、ランダム変数と一致した場合、徐々に回転を遅める。
            if elapsedTime >= randomTimer {
                rotationAngleStopper /= 1.0005
                rotationAngle += rotationAngleStopper
                // ルーレット停止後、タイマーを停止する。
                if rotationAngleStopper <= 0.005 {
                    // "ジャン"音
                    sounds.fileName = setting.jan
                    sounds.playSound()
                    
                    isShowResult = true
                    stopTime()
                    isStartRoulette = false
                    elapsedTime = 0
                    rotationAngleStopper = 1
                }
            } else {
                rotationAngle += 1
            }
            elapsedTime += 0.001
        }
    }
    
    ///　タイマーを停止
    /// - Parameters: なし
    /// - Returns: なし
    func stopTime() {
        timer.invalidate()
    }
}
