
import SwiftUI
import CoreData

struct ContentView: View {
    
    /// 被管理オブジェクトコンテキスト（ManagedObjectContext）の取得
    @Environment(\.managedObjectContext) private var context
    /// データ取得処理
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.timestamp, ascending: true)],
        predicate: nil
    ) private var tasks: FetchedResults<Task>
    
    init() {
        UITableView.appearance().backgroundColor = .init(named: "MainColor")
    }
    
    var body: some View {
        NavigationView {
            
            /// 取得したデータをリスト表示
            List {
                ForEach(tasks) { task in
                    /// タスクの表示
                    HStack {
                        Image(systemName: task.checked ? "checkmark.circle.fill" : "circle")
                        Text("\(task.name!)")
                        Spacer()
                    }
                    
                    /// タスクをタップでcheckedフラグを変更する
                    .contentShape(Rectangle())
                    .onTapGesture {
                        task.checked.toggle()
                        try? context.save()
                    }
                }
                .onDelete(perform: deleteTasks)
            }
            .navigationTitle("Todoリスト")
            /// ツールバーの設定
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
               
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink(destination: AddTaskView()) {
                        Image(systemName: "plus")
                            .font(.headline)
                            .padding()
                            .frame(width: 40, height: 40)
                            .accentColor(Color.white)
                            .background(Color.blue)
                            .cornerRadius(30)
                            .shadow(color: Color.black, radius: 3, x: 3, y: 3)
                    }
                }
            }
        }
    }
    
    /// タスクの削除
    /// - Parameter offsets: 要素番号のコレクション
    func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            context.delete(tasks[index])
        }
        try? context.save()
    }
}

/// タスク追加View
struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.presentationMode) var presentationMode
    @State private var task = ""
    
    var body: some View {
        Form {
            Section() {
                TextField("タスクを入力", text: $task)
            }
        }
        .navigationTitle("タスク追加")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("保存") {
                    /// タスク新規登録処理
                    let newTask = Task(context: context)
                    newTask.timestamp = Date()
                    newTask.checked = false
                    newTask.name = task
                    try? context.save()
                    /// 現在のViewを閉じる
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}
