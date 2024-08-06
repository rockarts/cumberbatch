//
//  ContentView.swift
//  cumberbatch
//
//  Created by Steven Rockarts on 2024-07-22.
//

import SwiftUI

class TaskManager: ObservableObject {
    @Published var tasks: [String] = []
    
    func addTask(_ task:String) {
        tasks.append(task)
    }
}

class UserSettings: ObservableObject {
    @Published var username: String = "Steven"
    @Published var isDarkMode: Bool = false
}

struct ContentView: View {
    @State private var movies: [Movie] = []
    
    var body: some View {
        NavigationView {
            List(movies) { movie in
                NavigationLink(destination: MovieDetailView(movie: movie)) {
                    MovieRow(movie: movie)
                }
            }
            .navigationTitle("Benedict Cumberbatch Movies")
            .onAppear {
                loadMovies()
            }
        }
    }
    
    func loadMovies() {
        MovieDBService.fetchBenedictCumberbatchMovies { fetchedMovies in
            self.movies = fetchedMovies
        }
    }
}

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w92\(movie.posterPath ?? "")")) { image in
                image.resizable()
            } placeholder: {
                Color.gray
            }
            .frame(width: 60, height: 90)
            .cornerRadius(5)
            
            Text(movie.title)
                .font(.headline)
        }
    }
}
//    @StateObject private var taskManager = TaskManager()
//    @StateObject private var userSettings = UserSettings()
//    
//    var body: some View {
//        NavigationView {
//            TaskListView()
//        }.environmentObject(taskManager)
//        .environmentObject(userSettings)
//    }


#Preview {
    ContentView()
}

struct TaskListView : View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var newTaskname: String = ""
    
    var body: some View {
        VStack {
            List(taskManager.tasks, id: \.self) { task in
                Text(task)
            }
            HStack {
                TextField("New Task", text: $newTaskname)
                Button("Add") {
                    taskManager.addTask(newTaskname)
                    newTaskname = ""
                }
            }.padding()
            NavigationLink("Settings") {
                SettingsView()
            }
            TaskCountView()
        }.navigationTitle("Tasks")
    }
}

struct TaskCountView: View {
    @EnvironmentObject var taskManager: TaskManager
    var body: some View {
        Text("Task Count: \(taskManager.tasks.count)")
    }
}

struct SettingsView: View {
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        Form {
            TextField("Username", text: $userSettings.username)
            Toggle("Dark Mode", isOn: $userSettings.isDarkMode)
            NavigationLink("Task Details") {
                TaskDetailsView()
            }
        }
        .navigationTitle("Settings")
    }
}

struct TaskDetailsView: View {
    @EnvironmentObject var taskManager: TaskManager
    @State private var selectedTask: String = ""
    
    var body: some View {
        VStack {
            Picker("Select Task", selection: $selectedTask) {
                ForEach(taskManager.tasks, id: \.self) { task in
                    Text(task)
                }
            }
            if !selectedTask.isEmpty {
                TaskEditView(taskName: $selectedTask)
            }
        }
        .navigationTitle("Task Details")
    }
}

// Task edit view
struct TaskEditView: View {
    @Binding var taskName: String
    
    var body: some View {
        TextField("Edit Task", text: $taskName)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
    }
}





enum SteveError: Error {
    case invalidInput
    case networkFailure
}

func negative(number: Int) throws -> Int {
    if number < 0 {
        throw SteveError.invalidInput
    }
    
    return number
}

func something() {
    do {
        let number = try negative(number: -1)
    } catch is SteveError {
        print("Negative")
    } catch {
        print("Some other error")
    }
}


