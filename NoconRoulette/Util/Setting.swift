//
//  Setting.swift
//  NoconRoulette
//
//  Created by 金子広樹 on 2023/08/01.
//

import SwiftUI

final class Setting {
    // 各種設定
    let maxTextCount: Int = 15                              // 最大テキスト文字数
    let maxListCount: Int = 15                              // 最大リスト数
    
    // 固定色
    let able: Color = Color("Able")                         // 文字・ボタン色
    let disable: Color = Color("Disable")                   // 背景色
    let highlight: Color = Color("Highlight")               // 強調色
    
    // サウンドファイル名
    let drumRoll: String = "DrumRoll"                       // ドラムロール音
    let jan: String = "Jan"                                 // 結果出力音
}
