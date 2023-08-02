////
////  RouletteView.swift
////  NoconRoulette
////
////  Created by 金子広樹 on 2023/08/01.
////
//
//import SwiftUI
//
//struct RouletteView: View {
//    let setting = Setting()
//
//    let dataCount: Int
//    let title: String
//
//    @Binding var count: Int                     // リストの現要素番号
//    @Binding var previousCount: Int             // 一つ前のリストの要素番号
//    @Binding var angle: Int                     // 一つの要素の角度
//
//    // ボタンサイズ
//    let strokeLineWidth: CGFloat = 80
//    let circleFrame: CGFloat = 250
//    let textPadding: CGFloat = 230
//
//    var listCount: CGFloat
//    var previousListCount: CGFloat
////    CGFloat((listCount - (count - 1) * angle) / 360)
//
//    var body: some View {
//        Circle()
//            .trim(from: CGFloat(previousCount / 360), to: CGFloat(listCount / 360))
//            .stroke(.blue, style: StrokeStyle(lineWidth: strokeLineWidth))
//            .frame(width: circleFrame, height: circleFrame)
//            .overlay {
//                VStack {
//                    Text(title)
//                        .foregroundColor(.white)
//                        .padding(.bottom, textPadding)
//                        .rotationEffect(Angle(degrees: 30 + listCount))
//                }
//            }
////        Circle()
////            .trim(from: 120/360, to: 240/360)
////            .stroke(.blue, style: StrokeStyle(lineWidth: strokeLineWidth))
////            .frame(width: circleFrame, height: circleFrame)
////            .overlay {
////                VStack {
////                    Text(title)
////                        .foregroundColor(.black)
////                        .padding(.bottom, textPadding)
////                        .rotationEffect(Angle(degrees: 30 + listCount))
////                }
////            }
//    }
//}
//
//struct RouletteView_Previews: PreviewProvider {
//    static var previews: some View {
//        RouletteView(dataCount: 3, title: "タイトル", count: .constant(1), previousCount: .constant(0), angle: .constant(120), listCount: 120, previousListCount: 0)
//    }
//}
