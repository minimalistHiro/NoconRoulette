//
//  ListView.swift
//  NoconRoulette
//
//  Created by 金子広樹 on 2023/08/01.
//

import SwiftUI

struct ListView: View {
    @Environment(\.managedObjectContext) var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Entity.createDate, ascending: true)])
    var data: FetchedResults<Entity>
    
    let setting = Setting()
    
    @FocusState private var focus: Bool
    @State private var isEditText: Bool = false         // テキスト編集中の有無
    @State private var isShowDeleteAlert: Bool = false  // 削除アラート表示有無
     
    var body: some View {
        NavigationStack {
            List {
                ForEach(data) { data in
                    if let title = data.title {
                        Button {
                            
                        } label: {
                            Text(title)
                                .listRowSeparator(.hidden)
                                .font(.system(size: 25))
                        }
                        .listRowSeparator(.hidden)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            Button(role: .destructive) {
                                rowRemove(data: data)
                            } label: {
                                Image(systemName: "trash")
                            }
                            .tint(.red)
                        }
                    }
                }
                // プラスボタン
                if isEditText {
                    DraftView(isEditText: $isEditText)
                        .focused($focus, equals: true)
                        .listRowSeparator(.hidden)
                } else {
                    if data.count <= setting.maxListCount - 1 {
                        Button {
                            isEditText = true
                        } label: {
                            Image(systemName: "circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40)
                                .foregroundColor(setting.able)
                                .overlay {
                                    Image(systemName: "plus")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20)
                                        .bold()
                                        .foregroundColor(setting.disable)
                                }
                        }
                        .listRowSeparator(.hidden)
                    }
                }
                Spacer()
                    .listRowSeparator(.hidden)
                Spacer()
                    .listRowSeparator(.hidden)
            }
            .listStyle(.inset)
            .environment(\.defaultMinListRowHeight, 70)
            .padding()
            .overlay(alignment: .bottomTrailing) {
                if data.count > 0 {
                    // 全削除ボタン
                    Button {
                        isShowDeleteAlert = true
                    } label: {
                        Image(systemName: "circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60)
                            .foregroundColor(Color("Able"))
                            .overlay {
                                Image(systemName: "trash")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25)
                                    .bold()
                                    .foregroundColor(Color("Disable"))
                            }
                    }
                    .padding(30)
                }
            }
            .alert("", isPresented: $isShowDeleteAlert) {
                Button("削除", role: .destructive) {
                    deleteAll()
                }
                Button("キャンセル", role: .cancel) {
                    isShowDeleteAlert = false
                }
            } message: {
                Text("全て削除しますか？")
            }

        }
    }
    
    /// 行を削除する。
    /// - Parameters:
    ///   - data: 削除するデータ
    /// - Returns: なし
    func rowRemove(data: FetchedResults<Entity>.Element) {
        viewContext.delete(data)
        do {
            try viewContext.save()
        } catch {
            fatalError("セーブに失敗")
        }
        updateNumber()
    }
    
    /// 全てのデータを削除する。
    /// - Parameters: なし
    /// - Returns: なし
    func deleteAll() {
        for data in data {
            viewContext.delete(data)
        }
        do {
            try viewContext.save()
        } catch {
            fatalError("セーブに失敗")
        }
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

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
