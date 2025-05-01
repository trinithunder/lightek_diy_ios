//
//  FileList.swift
//  lightek-diy
//
//  Created by Marlon on 4/14/25.
//

import Foundation
// SocialApp.swift (Entry Point)
import SwiftUI

//@main
//struct SocialApp: App {
//    var body: some Scene {
//        WindowGroup {
//            MainTabView()
//        }
//    }
//}

// MainTabView.swift
import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            WhatsAppCloneView()
                .tabItem { Label("Chat", systemImage: "message") }

            InstagramCloneView()
                .tabItem { Label("Feed", systemImage: "photo.on.rectangle") }

            TikTokCloneView()
                .tabItem { Label("Reels", systemImage: "play.rectangle.fill") }

            BumbleCloneView()
                .tabItem { Label("Match", systemImage: "heart.circle") }
        }
    }
}

// MARK: - 📲 Instagram Clone
struct InstagramCloneView: View {
    var body: some View {
        NavigationView {
            List(0..<10) { index in
                VStack(alignment: .leading) {
                    Text("@user\(index)")
                        .font(.headline)
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 200)
                        .overlay(Text("Post \(index)").foregroundColor(.black))
                }
                .padding()
            }
            .navigationTitle("Feed")
        }
    }
}

// MARK: - 📲 TikTok Clone
struct TikTokCloneView: View {
    var body: some View {
        TabView {
            ForEach(0..<5) { i in
                ZStack {
                    Color.black
                    Text("Video \(i)")
                        .foregroundColor(.white)
                        .font(.largeTitle)
                }
                .tag(i)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .ignoresSafeArea()
    }
}

// MARK: - 🧠 AuthenticationService
class AuthService {
    static let shared = AuthService()
    private init() {}

    func login(email: String, password: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://your-api.com/login") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            completion(true)
        }.resume()
    }
}

// MARK: - 💬 WhatsApp Clone
struct WhatsAppCloneView: View {
    @ObservedObject var messageService = MessageService()

    var body: some View {
        NavigationView {
            List(messageService.messages) { msg in
                HStack {
                    if msg.isMine { Spacer() }
                    VStack(alignment: .leading) {
                        if let content = msg.content {
                            Text(content)
                        }
                        if let imageURL = msg.imageURL {
                            Text("📷 Image: \(imageURL)")
                        }
                    }
                    .padding()
                    .background(msg.isMine ? Color.blue.opacity(0.2) : Color.gray.opacity(0.2))
                    .cornerRadius(8)
                    if !msg.isMine { Spacer() }
                }
            }
            .navigationTitle("Chat")
            .onAppear {
                messageService.startPolling(chatID: "123")
            }
        }
    }
}

class MessageService: ObservableObject {
    @Published var messages: [Message] = []
    @Published var isTyping: Bool = false

    func startPolling(chatID: String) {
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.fetchMessages(chatID: chatID)
            self.checkTypingStatus(chatID: chatID)
        }
    }

    func fetchMessages(chatID: String) {
        guard let url = URL(string: "https://your-api.com/chats/\(chatID)/messages") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            let decoded = try? JSONDecoder().decode([Message].self, from: data)
            DispatchQueue.main.async {
                self.messages = decoded ?? []
            }
        }.resume()
    }

    func checkTypingStatus(chatID: String) {
        guard let url = URL(string: "https://your-api.com/chats/\(chatID)/typing") else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let isTyping = try? JSONDecoder().decode(Bool.self, from: data) else { return }
            DispatchQueue.main.async {
                self.isTyping = isTyping
            }
        }.resume()
    }

    func sendImage(chatID: String, imageData: Data) {
        guard let url = URL(string: "https://your-api.com/chats/\(chatID)/images") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        request.httpBody = imageData

        URLSession.shared.uploadTask(with: request, from: imageData) { data, _, _ in }.resume()
    }
}

struct Message: Codable, Identifiable {
    var id: Int
    var content: String?
    var imageURL: String?
    var gifURL: String?
    var status: String // "sent", "delivered", "read"
    var isMine: Bool
}

// MARK: - 📲 AVKit Video Recording + Upload + Live
import AVKit
import PhotosUI

struct VideoRecorderView: UIViewControllerRepresentable {
    var onVideoCaptured: (URL) -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        picker.mediaTypes = ["public.movie"]
        picker.videoQuality = .typeHigh
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: VideoRecorderView

        init(_ parent: VideoRecorderView) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let url = info[.mediaURL] as? URL {
                parent.onVideoCaptured(url)
                uploadToRails(videoURL: url)
            }
            picker.dismiss(animated: true)
        }

        func uploadToRails(videoURL: URL) {
            guard let videoData = try? Data(contentsOf: videoURL) else { return }
            guard let url = URL(string: "https://your-api.com/videos/upload") else { return }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("video/mp4", forHTTPHeaderField: "Content-Type")
            URLSession.shared.uploadTask(with: request, from: videoData) { data, _, _ in }.resume()
        }
    }
}

// MARK: - ❤️ Bumble Engine w/ Animations + Likes
struct BumbleCloneView: View {
    @State private var cards: [String] = ["Alice", "Bob", "Cara"]
    @State private var offset: CGSize = .zero
    @State private var liked: [String] = []
    @State private var disliked: [String] = []

    var body: some View {
        ZStack {
            ForEach(cards, id: \.",") { name in
                CardView(name: name)
                    .offset(offset)
                    .gesture(DragGesture()
                        .onChanged { gesture in
                            self.offset = gesture.translation
                        }
                        .onEnded { value in
                            if value.translation.width < -100 {
                                swipeLeft(name: name)
                            } else if value.translation.width > 100 {
                                swipeRight(name: name)
                            }
                            self.offset = .zero
                        })
                    .animation(.spring(), value: offset)
            }
        }
    }

    func swipeLeft(name: String) {
        disliked.append(name)
        cards.removeAll { $0 == name }
        likeDislike(name: name, liked: false)
    }

    func swipeRight(name: String) {
        liked.append(name)
        cards.removeAll { $0 == name }
        likeDislike(name: name, liked: true)
    }

    func likeDislike(name: String, liked: Bool) {
        guard let url = URL(string: "https://your-api.com/matches") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["name": name, "liked": liked])
        URLSession.shared.dataTask(with: request) { _, _, _ in }.resume()
    }
}

struct CardView: View {
    let name: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25.0)
                .fill(Color.orange)
                .frame(width: 300, height: 400)
                .shadow(radius: 10)
            Text(name)
                .font(.largeTitle)
                .foregroundColor(.white)
        }
    }
}

