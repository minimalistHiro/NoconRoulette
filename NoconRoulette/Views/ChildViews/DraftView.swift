//
//  DraftView.swift
//  NoconRoulette
//
//  Created by 金子広樹 on 2023/08/02.
//

import SwiftUI

struct DraftView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entity.createDate, ascending: true)])
    var data: FetchedResults<Entity>
    
    let setting = Setting()
    @Binding var isEditText: Bool
    
    @FocusState private var focus: Bool
    @State private var newTitle: String = ""                // 新規タイトル
    
    var body: some View {
        TextField("", text: $newTitle)
            .font(.system(size: 20))
            .onSubmit {
                // タスクタイトルが空白でない場合のみ,新規タスクを作成.
                if newTitle.count > 0 {
                    create()
                    newTitle.removeAll()
                    focus = false
                    
                    // 続けてタスクを作成
                    if data.count >= setting.maxListCount {
                        isEditText = false
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            isEditText = true
                            focus = true
                        }
                    }
                } else {
                    isEditText = false
                    focus = false
                }
            }
            .focused($focus, equals: true)
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    focus = true
                }
            }
            .onChange(of: newTitle, perform: { value in
                // 最大文字数に達したら、それ以上書き込めないようにする。
                if value.count > setting.maxTextCount {
                    newTitle.removeLast(newTitle.count - setting.maxTextCount)
                }
            })
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button {
                            // タスクタイトルが空白でない場合のみ,新規タスクを作成.
                            if newTitle.count > 0 {
                                create()
                                newTitle.removeAll()
                                isEditText = false
                                focus = false
                            } else {
                                isEditText = false
                                focus = false
                            }
                        } label: {
                            Image(systemName: "checkmark")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25)
                                .foregroundColor(setting.able)
                        }
                    }
                }
            }
            .submitLabel(data.count >= setting.maxListCount - 1 ? .done : .next)
    }
    
    /// Modelに新規データを保存する。
    /// - Parameters: なし
    /// - Returns: なし
    private func create() {
        let newEntity = Entity(context: viewContext)
//        if newTitle == "" {
//            newEntity.title = "タイトル\(data.count + 1)"
//        } else {
            newEntity.title = newTitle
//        }
        newEntity.createDate = Date()
        newEntity.number = Int16(data.count)
        do {
            try viewContext.save()
        } catch {
            fatalError("セーブに失敗")
        }
        updateNumber()
    }
    
    /// 全てのnumberを更新する。
    /// - Parameters: なし
    /// - Returns: なし
    private func updateNumber() {
        var count: Int = 0// カウンター変数
        
        for data in data {
            count += 1
            data.number = Int16(count)
        }
        do {
            try viewContext.save()
        } catch {
            fatalError("セーブに失敗")
        }
    }
}

struct DraftView_Previews: PreviewProvider {
    static var previews: some View {
        DraftView(isEditText: .constant(true))
    }
}
