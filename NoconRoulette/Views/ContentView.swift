//
//  ContentView.swift
//  NoconRoulette
//
//  Created by 金子広樹 on 2023/08/01.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entity.createDate, ascending: true)])
    var data: FetchedResults<Entity>
    
    let setting = Setting()
    @ObservedObject var timerRun = TimerRun.shared
    
    @State private var isShowSheet: Bool = false            // シート表示有無
    var angle: Double { Double(360) / Double(data.count) }  // 一つの要素の角度
    
    // ボタンサイズ
    let strokeLineWidth: CGFloat = 80
    let smallCircleFrame: CGFloat = 150
    let circleFrame: CGFloat = 250
    let textPadding: CGFloat = 240
    let trianglePadding: CGFloat = 350
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                ForEach(data) { data in
                    if let title = data.title {
                        Circle()
                            .trim(from: CGFloat((Double(data.number - 1) * angle) / 360), to: CGFloat((Double(data.number) * angle) / 360))
                            .stroke(Color("Color\(data.number)"), style: StrokeStyle(lineWidth: strokeLineWidth))
                            .frame(width: circleFrame, height: circleFrame)
                            .overlay {
                                VStack {
                                    Text(title)
                                        .frame(width: CGFloat((smallCircleFrame - 50) * angle * 3.14 / 180), height: circleFrame / 3)
                                        .foregroundColor(.black)
                                        .padding(.bottom, textPadding)
                                        .rotationEffect(Angle(degrees: Double(90 - (angle / 2) + Double(data.number) * angle)))
                                }
                            }
                    }
                }
                .rotationEffect(.degrees(Double(timerRun.rotationAngle)))
                // データが一つ以上のみ表示。
                if data.count > 0 {
                    // 中心円
                    if !timerRun.isStartRoulette {
                        Circle()
                            .frame(width: smallCircleFrame, height: smallCircleFrame)
                            .foregroundColor(setting.disable)
                            .overlay {
                                Image(systemName: "gobackward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60)
                                    .foregroundColor(.blue)
                            }
                    }
                    Triangle()
                        .frame(width: 50, height: 50)
                        .padding(.bottom, trianglePadding)
                }
            }
            .onTapGesture {
                // 複数タップによるルーレットの加速を防止。
                if timerRun.isStartRoulette == false {
                    timerRun.isShowResult = false
                    timerRun.isStartRoulette = true
                    timerRun.startTime()
                }
            }
            
            // 結果表示テキスト
            if timerRun.isShowResult && data.count > 0 {
                Text(calculateResult())
                    .bold()
                    .font(.system(size: 25))
            } else {
                // レイアウト崩れ防止用。
                Text(" ")
                    .bold()
                    .font(.system(size: 25))
            }
            Spacer()
            
            // ルーレット編集ボタン
            if !timerRun.isStartRoulette {
                Button {
                    isShowSheet = true
                } label: {
                    if data.count > 0 {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .foregroundColor(setting.able)
                            .overlay {
                                Image(systemName: "pencil")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                    .bold()
                                    .foregroundColor(setting.disable)
                            }
                    } else {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .foregroundColor(setting.able)
                            .overlay {
                                Image(systemName: "plus")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                    .bold()
                                    .foregroundColor(setting.disable)
                            }
                    }
                }
                .padding()
            } else {
                // レイアウト崩れ防止用。
                Image("")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)
                    .padding()
            }
        }
        .sheet(isPresented: $isShowSheet) {
            ListView()
        }
    }
    
    /// 回転角度から結果を出力する。
    /// - Parameters: なし
    /// - Returns: 結果テキスト。
    private func calculateResult() -> String {
        var resultAngle = Int(timerRun.rotationAngle) % 360     // ルーレット相対回転角度
        
        // 三角矢印が上部にあるため、90度分補正をかける。
        resultAngle += 90
        if resultAngle > 360 {
            resultAngle -= 360
        }
        var result = Int(Double(resultAngle) / angle)           // 結果要素番号
        result = data.count - result
        
        for data in data {
            if data.number == result {
                return data.title ?? "エラー"
            }
        }
        return "エラー"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
