//
//  Triangle.swift
//  NoconRoulette
//
//  Created by 金子広樹 on 2023/08/02.
//

import SwiftUI

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}

struct Triangle_Previews: PreviewProvider {
    static var previews: some View {
        Triangle()
    }
}
