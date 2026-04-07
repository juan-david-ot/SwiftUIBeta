//
//  ContentView.swift
//  SwiftUIBeta
//
//  Created by JuanDa on 29/7/24.
//

import SwiftUI
import Foundation
import Combine
import AVKit
import MapKit
import CoreLocation
import RegexBuilder
import PhotosUI
import Charts
import VisionKit
import ActivityKit

struct Device {
    let title: String
    let imageName: String
}

let home = [
    Device(title: "iPhone", imageName: "iphone"),
    Device(title: "iPad", imageName: "ipad"),
    Device(title: "AirPods", imageName: "airpods"),
    Device(title: "Apple Watch", imageName: "applewatch")
]

let work = [
    Device(title: "Laptop", imageName: "laptopcomputer"),
    Device(title: "Mac Mini", imageName: "macmini"),
    Device(title: "Mac Pro", imageName: "macpro.gen3"),
    Device(title: "Displays", imageName: "display.2"),
    Device(title: "Apple TV", imageName: "appletv")
]

let devices = [
    Device(title: "iPhone", imageName: "iphone"),
    Device(title: "iPad", imageName: "ipad"),
    Device(title: "PC", imageName: "pc"),
    Device(title: "TV", imageName: "4k.tv"),
    Device(title: "iPod", imageName: "ipod"),
    Device(title: "Laptop", imageName: "laptopcomputer")
]

let names = [
    "JuanDa",
    "Dixamo",
    "Novamix",
    "Julian",
    "Swift",
    "Rulas",
    "Auron",
    "Rubius"
]

struct SoundModel: Hashable {
    
    let name: String
    
    func getUrl () -> URL {
        return URL(string: Bundle.main.path(forResource: name, ofType: "wav")!)!
    }
    
}

class SoundPlayer {
    
    var audio: AVAudioPlayer?
    
    func play(withURL url: URL) {
        audio = try! AVAudioPlayer(contentsOf: url)
        audio?.prepareToPlay()
        audio?.play()
    }
    
}

let soundsArray: [SoundModel] = [
    .init(name: "1"),
    .init(name: "2"),
    .init(name: "3"),
    .init(name: "4"),
    .init(name: "5")
]

struct Fruit: Hashable, Identifiable {
    var id = UUID()
    var name: String
}

var fruits: [Fruit] = [
    .init(name: "Orange🍊"),
    .init(name: "Apple🍎"),
    .init(name: "Cherries🍒"),
    .init(name: "Banana🍌"),
    .init(name: "Strawberry🍓"),
    .init(name: "Watermelon🍉"),
    .init(name: "Lemon🍋"),
    .init(name: "Blueberries🫐")
]

struct Developer: Hashable {
    let name: String
}

struct YoutubeStats: Identifiable, Hashable {
    let id: String = UUID().uuidString
    let date: Date
    let views: Int
}

struct Metric: Identifiable {
    let id: String = UUID().uuidString
    var source: String
    var data: [YoutubeStats]
}

extension Date {
    func last(day: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: day, to: .now)!
    }
}

let youtubeVideoModel: [YoutubeStats] = [
    .init(date: .now.last(day: -1), views: 400),
    .init(date: .now.last(day: -2), views: 900),
    .init(date: .now.last(day: -3), views: 690),
    .init(date: .now.last(day: -4), views: 550),
    .init(date: .now.last(day: -5), views: 800),
    .init(date: .now.last(day: -6), views: 820),
    .init(date: .now.last(day: -7), views: 600)
]

let webVideoModel: [YoutubeStats] = [
    .init(date: .now.last(day: -1), views: 300),
    .init(date: .now.last(day: -2), views: 800),
    .init(date: .now.last(day: -3), views: 490),
    .init(date: .now.last(day: -4), views: 350),
    .init(date: .now.last(day: -5), views: 800),
    .init(date: .now.last(day: -6), views: 120),
    .init(date: .now.last(day: -7), views: 600)
]

var metrics: [Metric] = [
    .init(source: "YouTube", data: youtubeVideoModel),
    .init(source: "Web", data: webVideoModel)
]

var viewsAverage: Double {
    let totalViews = youtubeVideoModel.reduce(0) { result, info in
        return result + info.views
    }
    return Double(totalViews / youtubeVideoModel.count)
}

enum DeliveryStatus: String, Codable {
    case none = ""
    case sent = "Enviado"
    case inTransit = "En reparto"
    case delivered = "Entregado"
}

struct DeliveryAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        var deliveryStatus: DeliveryStatus
        var productName: String
        var estimatedArrivalDate: String
    }
}

final class DeliveryActivityUseCase {
    static func startActivity(deliveryStatus: DeliveryStatus, productName: String, estimatedArrivalDate: String) throws -> String {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return "" }
        let initialState = DeliveryAttributes.ContentState(deliveryStatus: deliveryStatus, productName: productName, estimatedArrivalDate: estimatedArrivalDate)
        
        let clearDate: Date = .now + 3600
        let activityContent = ActivityContent(state: initialState, staleDate: clearDate)
        
        let attributes = DeliveryAttributes()
        
        do{
            let activity = try Activity.request(attributes: attributes, content: activityContent)
            
            return activity.id
        }
        catch {
            throw error
        }
    }
}

struct ContentView: View {
    
    @AppStorage("appStorageName") var appStorageName: String = ""
    
    @StateObject private var contentViewModel = ContentViewModel()
    
    @StateObject private var viewModel = ViewModel()
    
    @State var counter: Int = 0
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var text: String = ""
    
    @State var date: Date = Date()
    
    @State var color: Color = .blue
    
    @State var isLoading: Bool = false
    @State var progress: Float = 0.0
    
    @State var isActive: Bool = false
    
    @State var slideCounter: Float = 0.0
    @State var isEditing: Bool = false
    
    let elements = 1...500
    var gridItems = [ GridItem(.fixed(100)), GridItem(.adaptive(minimum: 20)), GridItem(.flexible(minimum: 20))]
    
    @State var offset: CGSize = .zero
    
    @SceneStorage("tweet") private var tweet: String = ""
    
    private let url = URL(string: "https://assetsio.gnwcdn.com/spider-man-remastered-pc.jpg?width=1200&height=1200&fit=crop&quality=100&format=png&enable=upscale&auto=webp")
    
    let videoPlayerUrl = URL(string: "https://media0.giphy.com/media/nZYasmPnlRT1oyHDlV/giphy480.mp4")!
    
    private let soundPlayer = SoundPlayer()
    
    @State var rotationAngle: Angle = Angle.degrees(0)
    
//    @StateObject var locationViewModel = LocationViewModel()
    
    @State var scale: CGFloat = 1.0
    
    @GestureState var isDetectingLongPress = false
    
    var longPress: some Gesture {
        LongPressGesture(minimumDuration: 3)
            .updating($isDetectingLongPress) { currentState, gestureState, transaction in
                gestureState = currentState
                transaction.animation = .easeIn(duration: 3.0)
            }
            .onEnded { _ in
                print("Has pulsado!")
            }
    }
    
    let developer: Developer = .init(name: "Dixamo")
    
    @State private var path = NavigationPath()
    
    @State var regexText = "sfsdjfslj hello@hello.com sj jlsfjldj lsfjslfjsjflsj swift@gmail.com wfhjsldjgdslsfjsldj fklsdjfls jdljf sl #testeando fjsfjslkjfsljk #teamo djfhajf jdajfalksd js jds elmejor@cr7.com fsjklafslkfs"
    
    @State private var hashtags: String = ""
    
    @State private var emails: String = ""
    
    @State var selectedDates: Set<DateComponents> = []
    @State var finalDates: String = ""
    let dateURL = URL(string: "http://www.apple.com/es")
    
    @State var showSheet: Bool = false
    
    @State private var value: Double = 0.0
    
    @State var images: [Image] = [Image(systemName: "photo.on.rectangle.angled")]
    @State var photoSelecction: PhotosPickerItem?
    
    @State var offsetY = 0.0
    let gradient = Gradient(colors: [Color(red: 40/255, green: 13/255, blue: 88/255), .black])
    
    @StateObject var scanProvider = ScanProvider()
    
    @State var productName: String = "MacBook Pro 1900€"
    @State var currentDeliveryState: DeliveryStatus = .none
    @State var activityIdentifier: String = ""
    
    func checkHashtags() {
        
        //let regex = try! Regex("#[a-z0-9]+")
        let regex = Regex {
            "#"
            OneOrMore(.word)
        }
        
        let match = regexText.matches(of: regex)
        match.forEach { value in
            let lowerBounds = value.range.lowerBound
            let upperBounds = value.range.upperBound
            let hashtag = regexText[lowerBounds...upperBounds]
            hashtags.append(String(hashtag))
        }
        
    }
    
    func checkEmails() {
        
        let regex = /\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b/
        
        let match = regexText.matches(of: regex)
        match.forEach { value in
            let lowerBounds = value.range.lowerBound
            let upperBounds = value.range.upperBound
            let email = regexText[lowerBounds...upperBounds]
            emails.append(String(email))
        }
        
    }
    
    func getDatesFormatted() {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/YY"
        let dates = selectedDates.compactMap{ Calendar.current.date(from: $0) }.map { formatter.string(from: $0) }
        
        finalDates = dates.joined(separator: "\n")
        
    }
    
    func updateValueToString() -> String {
        
        let formattedString: Int = Int(self.value * 100)
        return "\(formattedString)%"
        
    }
    
    func changeImage(newItem: PhotosPickerItem?) -> Void {
        
        guard let newItem = newItem else { return }
        
        newItem.loadTransferable(type: Data.self) { result in
            DispatchQueue.main.async {
                guard photoSelecction == self.photoSelecction else { return }
                switch result {
                    case .success(let data):
                    let uiImage = UIImage(data: data!)
                    self.images.append(Image(uiImage: uiImage!))
                    case .failure(let error):
                    print("Error load transferable: \(error)")
                    self.images.append(Image(systemName: "multiple.circle.fill"))
                }
            }
        }
        
    }
    
    func buyProduct() {
        currentDeliveryState = .sent
        
        do {
            activityIdentifier = try DeliveryActivityUseCase.startActivity(deliveryStatus: currentDeliveryState, productName: productName, estimatedArrivalDate: "21:00")
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        
        /*      STACKS      */
        
//        ZStack {
//            VStack(
//                alignment: .leading,
//                spacing: 20
//            ) {
//                Text("Siguiendo")
//                    .font(.largeTitle)
//                    .bold()
//                Text("CANALES RECOMENDADOS")
//                    .foregroundStyle(.gray)
//                HStack {
//                    Rectangle()
//                        .foregroundStyle(.blue)
//                        .frame(width: 118, height: 68)
//                    VStack(alignment: .leading) {
//                        HStack {
//                            Circle()
//                                .foregroundStyle(.blue)
//                                .frame(width: 18, height: 18)
//                            Text("username")
//                                .font(.headline)
//                        }
//                        Text("straming de programación...")
//                            .foregroundStyle(.gray)
//                        Text("Solo hablando")
//                            .foregroundStyle(.gray)
//                    }
//                }
//            }
//            Text("Oye Calvo!! Suscribete!!")
//                .font(.largeTitle)
//                .bold()
//                .foregroundStyle(.red)
//                .underline()
//                .background(Color.black)
//                .rotationEffect(.degrees(-20))
//        }
        
        /*      IMAGES      */
        
//        Image("apple")
//            .renderingMode(.template)
//            .resizable()
//            .scaledToFit()
//            .frame(width: 96/*, height: 68*/)
//            .foregroundStyle(.blue)
//
//        Image("youtube")
//            .resizable(resizingMode: .tile)
        
        /*      ICONS       */
        
//        Image(systemName: "moon.circle.fill")
//        //.renderingMode(.original)
//            .resizable()
//            .scaledToFit()
//            .frame(width: 200)
//            .foregroundStyle(.indigo)
        
        /*      STATE       */
        
//        VStack {
//            Text("\(counter)")
//                .font(.custom("SF Pro Rounded", size: 150))
//                .bold()
//
//            Spacer().frame(height: 100)
//
//            Button("Sumar") {
//                counter += 1
//            }
//            .buttonStyle(.borderedProminent)
//            .font(.custom("SF Pro Rounded", size: 50))
//        }
        
        /*      LABEL       */
        
//        Label(
//            title: {
//                Text("Suscribete")
//            },
//            icon: {
//                Image(systemName: "hand.thumbsup.fill")
//            }
//        )
//        .font(.largeTitle)
//        //.labelStyle(IconOnlyLabelStyle())
//        .labelStyle(TitleOnlyLabelStyle())
        
        /*      TEXT        */
        
//        VStack {
//            Text("Bieeeenvenidos mis queridisimos amigos calvos, calvas, gente de poco pelo, de pelo pobre, de pelo escaso, de pelo casi inexistente")
//                .font(.largeTitle)
//                .underline()
//                .rotation3DEffect(
//                    .degrees(20),
//                    axis: (x: 1.0, y: 0.0, z: 0.0)
//                )
//                .shadow(color: .gray, radius: 2, x: 0, y: 10)
//                .lineLimit(6)
//                .lineSpacing(10)
//                .padding()
//            Text(Date(), style: .date)
//            Text(Date(), style: .timer)
//            Text(Date().addingTimeInterval(3600), style: .timer)
//            Text(Date(), style: .time)
//        }
        
        /*      BUTTON      */
        
//        VStack {
//            Button(
//                action: {
//                    print("Suscrito")
//                }
//            ) {
//                Text("Suscríbete".uppercased())
//            }
//            .font(.largeTitle)
//            .fontWeight(.bold)
//            .foregroundStyle(.white)
//            .padding()
//            .background(Color.red)
//            .cornerRadius(10)
//            .shadow(radius: 10)
//
//            Button(
//                action: {
//                    print("Like")
//                },
//                label: {
//                    Circle()
//                        .fill(Color.blue)
//                        .frame(width: 200, height: 200)
//                        .shadow(radius: 10)
//                        .overlay(content: {
//                            Image(systemName: "hand.thumbsup.fill")
//                                .foregroundStyle(.white)
//                                .font(.system(size: 70, weight: .bold))
//                        })
//                }
//            )
//        }
        
        /*      TEXTFIELD       */
        
//        VStack {
//            TextField("Username", text: $username)
//                .keyboardType(.emailAddress)
//                .autocorrectionDisabled(true)
//                .padding(8)
//                .font(.headline)
//                .background(Color.gray.opacity(0.3))
//                .cornerRadius(6)
//                .padding(.horizontal, 60)
//                .padding(.top, 40)
//                .onChange(of: username) { oldValue, newValue in
//                    print(username)
//                }
//            SecureField("Password", text: $password)
//                .keyboardType(.emailAddress)
//                .autocorrectionDisabled(true)
//                .padding(8)
//                .font(.headline)
//                .background(Color.gray.opacity(0.3))
//                .cornerRadius(6)
//                .padding(.horizontal, 60)
//                .padding(.top, 40)
//                .onChange(of: password) { oldValue, newValue in
//                    print(password)
//                }
//            Spacer()
//        }
        
        /*      TEXTEDITOR      */
        
//        VStack {
//            TextEditor(text: $text)
//                .font(.title)
//                .textInputAutocapitalization(.never)
//                .autocorrectionDisabled(true)
//                .foregroundStyle(.blue)
//                .padding()
//                .onChange(of: text) { oldValue, newValue in
//                    counter = newValue.count
//                }
//            Text("\(counter)")
//                .foregroundStyle(counter <= 280 ? .green : .red)
//                .font(.largeTitle)
//        }
        
        /*      DATEPICKER      */
        
//        Form {
//            DatePicker("Selecciona Fecha", selection: $date)
//                .datePickerStyle(WheelDatePickerStyle())
//            //DatePicker("Selecciona Fecha", selection: $date, in: Date()...Date(), displayedComponents: .date)
//            Text(date, style: .date)
//                .bold()
//        }
        
        /*      COLORPICKER     */
        
//        VStack {
//            Rectangle()
//                .foregroundStyle(color)
//                .frame(width: 400, height: 90)
//            ColorPicker("Selecciona un color", selection: $color)
//            Spacer()
//        }
//        .padding()
        
        /*     PROGRESS VIEW    */
        
//        VStack {
//            if isLoading {
//                ProgressView("Cargando...")
//                    .scaleEffect(2)
//            }
//            Button("Cargando") {
//                isLoading = !isLoading
//            }
//            .padding(.vertical, 40)
//
//            ProgressView(value: progress)
//            Button("Cargando") {
//                progress += 0.1
//            }
//            .padding(.top, 40)
//        }
//        .padding(.horizontal, 30)
        
        /*          LINK        */
        
//        Link("Ir a GitHub", destination: URL(string: "https://www.apple.com")!)
//        Link(destination: URL(string: UIApplication.openSettingsURLString)!, label: {
//            Label("Settings", systemImage: "gear")
//                .font(.title)
//                .foregroundStyle(.white)
//                .padding()
//                .background(Color.blue)
//                .cornerRadius(12)
//        })
        
        /*       TOGGLE         */
        
//        Form {
//            Toggle("Activado", isOn: $isActive)
//            Text("\(isActive.description)")
//        }
        
        /*      STEPPER        */
        
//        Form {
//            Stepper("iPhone \(counter)", value: $counter, in: 0...10, step: 2)
//            Stepper(
//                "iPhone \(counter)",
//                onIncrement: {
//                    counter += 1
//                    print(counter)
//                },
//                onDecrement: {
//                    counter -= 1
//                    print(counter)
//                }
//            )
//        }
        
        /*        SLIDER         */
        
//        Form {
//            Slider(
//                value: $slideCounter,
//                in: 0...10,
//                step: 1,
//                label: {
//                    Text("Mueve el selector")
//                },
//                minimumValueLabel: {
//                    Text("Min")
//                },
//                maximumValueLabel: {
//                    Text("Max")
//                },
//                onEditingChanged: { (editing) in
//                    isEditing = editing
//                }
//            )
//        }
//        Text("\(slideCounter)")
//            .foregroundStyle(isEditing ? .green : .black)
        
        /*        LAZYGRIDS      */
        
//        ScrollView {
//            LazyVGrid(columns: [GridItem(.fixed(100)), GridItem(.fixed(100)), GridItem(.fixed(100))], content: {
//                Text("Placeholder")
//                Text("Placeholder")
//                Text("Placeholder")
//            })
//
//            LazyVGrid(columns: gridItems, content: {
//                ForEach(elements, id: \.self) { element in
//                    VStack {
//                        Circle()
//                            .frame(height: 40)
//                        Text("\(element)")
//                    }
//                }
//            })
//
//            ScrollView(.horizontal) {
//                LazyHGrid(rows: gridItems, content: {
//                    ForEach(elements, id: \.self) { element in
//                        VStack {
//                            Circle()
//                                .frame(height: 40)
//                            Text("\(element)")
//                        }
//                    }
//                })
//            }
//        }
        
        /*        FORM         */
        
//        Form {
//            Section(header: Text("Ajustes")){
//                TextField("Nombre del Dispositivo", text: $username)
//                Toggle("Wi-Fi", isOn: $isActive)
//            }
//
//            Section(
//                header: Text("Cuenta"),
//                footer: HStack {
//                    Spacer()
//                    Label("Version 1.0", systemImage: "iphone")
//                    Spacer()
//                }
//            ) {
//                DatePicker("Fecha", selection: $date)
//                ColorPicker("Color", selection: $color)
//            }
//        }
        
        /*          LIST        */
        
//        List {
//            ForEach(home + work, id: \.title) { device in
//                Label(device.title, systemImage: device.imageName)
//            }
//            Section(header: Text("Casa")) {
//                ForEach(home, id: \.title) { device in
//                    Label(device.title, systemImage: device.imageName)
//                }
//            }
//            Section(header: Text("Trabajo")) {
//                ForEach(work, id: \.title) { device in
//                    Label(device.title, systemImage: device.imageName)
//                }
//            }
//        }
        
        /*        NAVIGATION      */
        
//        NavigationView {
//            List {
//                NavigationLink("Opcion 1", destination: Text("Opcion 1"))
//                NavigationLink("Opcion 2", destination: Button("Pulsame") {print("Hola desarrollador")})
//                NavigationLink("Opcion 3", destination: Text("Opcion 3"))
//                NavigationLink("Opcion 4", destination: Text("Opcion 4"))
//            }
//            .navigationTitle("Menu")
//            //.navigationBarTitleDisplayMode(.inline)
//            .toolbar() {
//                ToolbarItem(placement: .topBarTrailing){
//                    Button("Done") {
//                        print("navBar")
//                    }
//                }
//            }
//        }
        
        /*         TABVIEW       */
        
//        TabView {
//            RoundedRectangle(cornerRadius: 20)
//                .padding()
//                .foregroundStyle(.blue)
//
//            RoundedRectangle(cornerRadius: 20)
//                .padding()
//                .foregroundStyle(.red)
//            HomeView()
//                .tabItem {
//                    Label("Home", systemImage: "house.fill")
//                }
//            ProfileView()
//                .tabItem {
//                    Label("Profile", systemImage: "person.crop.circle.fill")
//                }
//        }
//        .tint(.green)
//        .tabViewStyle(PageTabViewStyle())
        
        /*         MODALS         */
        
//        VStack {
//            Text("View 1")
//                .padding()
//            Button("Ok") {
//                isActive = true
//            }
//        }
//        .fullScreenCover(
//            isPresented: $isActive,
//            onDismiss: { isActive = false },
//            content: {
//                ZStack {
//                    Color.red.ignoresSafeArea()
//                    Button("BIenvenido a la App") {
//                        isActive = false
//                    }
//                }
//            }
//        )
//        .sheet(
//            isPresented: $isActive,
//            onDismiss: { isActive = false },
//            content: {
//                ZStack {
//                    Color.red.ignoresSafeArea()
//                    Button("BIenvenido a la App") {
//                        isActive = false
//                    }
//                }
//            }
//        )
        
        /*         ALERT           */
        
//        VStack {
//            Text("Suscribete")
//                .padding()
//            Button("Aceptar") {
//                isActive = true
//            }
//        }
//        .alert(
//            Text("Suscribete"),
//            isPresented: $isActive,
//            actions: {
//                Button("Aceptar") {
//                    print("Aceptado")
//                }
//                Button("Cancelar") {
//                    print("Cancelado")
//                }
//            },
//            message: {
//                Text("Videos cada semana")
//            }
//        )
//        .alert(
//            isPresented: $isActive,
//            content: {
//                Alert(
//                    title: Text("Suscribete"),
//                    message: Text("Videos cada semana"),
//                    primaryButton: .default(
//                        Text("Aceptar"),
//                        action: {
//                            print("Aceptado")
//                        }
//                    ),
//                    secondaryButton: .destructive(Text("Cancelar"))
//                )
//            }
//        )
        
        /*       ACTIONSHEET     */
        
//        VStack {
//            Text("Suscribete")
//                .padding()
//            Button("Aceptar") {
//                isActive = true
//            }
//        }
//        .actionSheet(
//            isPresented: $isActive,
//            content: {
//                ActionSheet(
//                    title: Text("Aprende Swift"),
//                    message: Text("Elige una opcion"),
//                    buttons: [
//                        .default(
//                            Text("SwiftUI"),
//                            action: {
//                                print("Aprende SwiftUI")
//                            }
//                        ),
//                        .default(
//                            Text("XCode"),
//                            action: {
//                                print("Aprende XCode")
//                            }
//                        ),
//                        .destructive(Text("Cancelar"))
//                    ])
//            }
//        )
        
        /*      CONTEXTMENU        */
        
//        Text("Manten Pulsado")
//            .padding()
//            .contextMenu(
//                menuItems: {
//                    Button("SwiftUI") {
//                        print("Aprende Swift")
//                    }
//                    Button("XCode") {
//                        print("Aprende XCode")
//                    }
//                    Button(
//                        action: {
//                            print("Desarrollo iOS")
//                        },
//                        label: {
//                            Label("iPhone", systemImage: "iphone")
//                        }
//                    )
//                }
//            )
        
        /*      TAPGESTURE       */
        
//        RoundedRectangle(cornerRadius: 20)
//            .frame(width: 100, height: 100)
//            .onTapGesture(count: 2) {
//                print("Ha intereactuado con la pantalla")
//            }
//            .gesture(
//                TapGesture(count: 2)
//                    .onEnded({ _ in
//                        print("Ha interactuado con la pantalla")
//                    })
//            )
        
        /*       DRAGGESTURE     */
        
//        RoundedRectangle(cornerRadius: 50)
//            .glassEffect(.clear.interactive())
//            .frame(width: 100, height: 100)
//            .offset(x: offset.width, y: offset.height)
//            .gesture(
//                DragGesture()
//                    .onChanged({ value in
//                        withAnimation(.bouncy) {
//                            offset = value.translation
//                        }
//                    })
//                    .onEnded({ value in
//                        withAnimation(.spring) {
//                            offset = .zero
//                        }
//                    })
//            )
        
        /*      STATE/BINDING     */
        
//        CounterView(counter: $counter)
        
        /*      STATEOBJECT       */
        
//        CounterView(counter: $counter)
//        ListVideosView(contentViewModel: contentViewModel)
//        Spacer()
        
        /*      ENVIROMENTOBJECT    */
        
//        VStack {
//            Text("Contador: \(viewModel.counter)")
//                .bold()
//                .font(.largeTitle)
//            Text("Vista 1")
//                .padding()
//            View2()
//        }
//        .environmentObject(viewModel)
        
        /*       APPSTORAGE        */
        
//        Form {
//            TextField("Username", text: $username)
//            HStack {
//                Spacer()
//                Button("Guardar") {
//                    appStorageName = username
//                }
//                .padding()
//                Spacer()
//            }
//            HStack {
//                Spacer()
//                Button("Mostrar") {
//                    print(UserDefaults.standard.string(forKey: "appStorageName"))
//                }
//                .padding()
//                Spacer()
//            }
//        }
//        .onAppear{
//            username = appStorageName
//        }
        
        /*      SCENESTORAGE       */
        
//        Form {
//            TextEditor(text: $tweet)
//                .frame(width: 300, height: 300)
//            Toggle("Publicar a la mejor hora", isOn: $isActive)
//            HStack {
//                Spacer()
//                Button(isActive ? "Publicar a la mejor hora" : "Publicar ahora") {
//                    print("Publicando...")
//                }
//                Spacer()
//            }
//        }
        
        /*      ASYNCIMAGE      */
        
//        AsyncImage(
//            url: url,
//            content: { image in
//                image
//                    .resizable()
//                    .scaledToFit()
//                    .cornerRadius(20)
//                    .padding()
//            },
//            placeholder: {
//                ProgressView()
//            }
//        )
        
        /*   SWIPEACTIONS   */
        
//        NavigationView {
//            List {
//                ForEach(devices, id: \.title) { device in
//                    Label(device.title, systemImage: device.imageName)
//                        .swipeActions{
//                            Button(
//                                action: {
//                                    print("Favorito")
//                                },
//                                label: {
//                                    Label("Favorito", systemImage: "star.fill")
//                                }
//                            )
//                            .tint(.yellow)
//                            Button(
//                                action: {
//                                    print("Compartir")
//                                },
//                                label: {
//                                    Label("Compartir", systemImage: "square.and.arrow.up")
//                                }
//                            )
//                            .tint(.blue)
//                        }
//                        .swipeActions(edge: .leading) {
//                            Button(
//                                action: {
//                                    print("Eliminar")
//                                },
//                                label: {
//                                    Label("Eliminar", systemImage: "trash.fill")
//                                }
//                            )
//                            .tint(.red)
//                        }
//                }
//            }
//            .refreshable(action: {
//                print("Refresh")
//            })
//        }
//        .navigationTitle("Devices")
        
        /*      GEOMETRYREADER    */
        
//        GeometryReader { proxy in
//            VStack {
//                Text("Width: \(proxy.size.width)")
//                    .background(Color.orange)
//                    .padding()
//                Text("Heigth: \(proxy.size.height)")
//                    .background(Color.orange)
//                    .padding()
//                Text("Coordinates Local: \(proxy.frame(in: .local).debugDescription)")
//                    .background(Color.orange)
//                    .padding()
//                Text("Coordinates Global: \(proxy.frame(in: .global).debugDescription)")
//                    .background(Color.orange)
//                    .padding()
//            }
//        }
//        .background(Color.red)
//        .frame(width: 300, height: 300)
//
//        GeometryReader { proxy in
//            VStack(spacing: 0) {
//                HStack(spacing: 0) {
//                    Rectangle()
//                        .foregroundStyle(.green)
//                        .overlay(Text("1"))
//                        .frame(
//                            width: proxy.size.width / 2,
//                            height: proxy.size.height / 2
//                        )
//                    Rectangle()
//                        .foregroundStyle(.orange)
//                        .overlay(Text("2"))
//                        .frame(
//                            width: proxy.size.width / 2,
//                            height: proxy.size.height / 2
//                        )
//                }
//                Rectangle()
//                    .foregroundStyle(Color.purple)
//                    .overlay(Text("3"))
//                    .frame(
//                        width: proxy.size.width,
//                        height: proxy.size.height / 2
//                    )
//            }
//        }
//        .background(.red)
//
//        ScrollView(showsIndicators: false) {
//            VStack {
//                ForEach(names, id: \.self) { name in
//                    GeometryReader { proxy in
//                        VStack {
//                            Text("\(proxy.frame(in: .global).minY)")
//                            Spacer()
//                            Text("\(name)")
//                                .frame(width: 370, height: 200)
//                                .background(Color.green)
//                                .cornerRadius(20)
//                            Spacer()
//                        }
//                        .shadow(color: .gray, radius: 10, x: 0, y: 0)
//                        .rotation3DEffect(
//                            Angle(degrees: Double(proxy.frame(in: .global).minY)),
//                            axis: (x: 0.0, y: 10.0, z: 10.0)
//                        )
//                    }
//                    .frame(width: 370, height: 300)
//                }
//            }
//            .padding(.trailing)
//        }
//        .padding(.horizontal)
        
        /*      VIEWMODIFIER       */
        
//        VStack {
//            Text("Funciona??")
//                .padding()
//            Button("No se, vamos a ver") {
//                print("Funciona")
//            }
//            .buttonModifier()
//        }
        
        /*      PREFERENCEKEY     */
        
//        CustomTitleView {
//            VStack {
//                Text("Probando")
//                    .padding()
//                    .preference(key: CustomTitleKey.self, value: "Bugisoft 1")
//                Text("Probando")
//                    .padding()
//                    .preference(key: CustomTitleKey.self, value: "Bugisoft 2")
//            }
//        }
        
        /*       VIDEOPLAYER     */
        
//        VStack {
//            VideoPlayer(player: .init(url: Bundle.main.url(forResource: "CityFootie", withExtension: "MOV")!)){
//                Text("Desliza con el dedo para adelantar el video")
//                    .bold()
//                    .foregroundStyle(Color.blue)
//                    .ignoresSafeArea()
//                Spacer()
//            }
//            VideoPlayer(player: .init(url: videoPlayerUrl)) {
//                Text("Desliza con el dedo para adelantar el video")
//                    .bold()
//                    .foregroundStyle(Color.blue)
//                    .ignoresSafeArea()
//                Spacer()
//            }
//            Text("Arrastra un video aqui!!")
//                .bold()
//                .padding(60)
//        }
//        .ignoresSafeArea()
        
        /*      AUDIOPLAYER     */
        
//        List {
//            ForEach(soundsArray, id: \.self) { sound in
//                Button("Play \(sound.name)") {
//                    soundPlayer.play(withURL: sound.getUrl())
//                }
//            }
//        }
        
        /*      ROTATIONGESTURE    */
        
//        NavigationView {
//            VStack {
//                Text("La view giratoria giratoria, siempre gira, pero nunca toria!!")
//                    .bold()
//                    .padding()
//                    .foregroundStyle(Color.white)
//                    .frame(width: 360, height: 100)
//                    .background(Color.red)
//                    .cornerRadius(20)
//                    .rotationEffect(rotationAngle)
//                    .gesture(
//                        RotationGesture()
//                            .onChanged({ angle in
//                                rotationAngle = angle
//                            })
//                            .onEnded({ _ in
//                                withAnimation {
//                                    rotationAngle = .degrees(0)
//                                }
//                            })
//                    )
//            }
//            .navigationTitle("La view giratoria")
//        }
        
        /*          MAPKIT        */
        
//        VStack {
//            Map(coordinateRegion: $locationViewModel.userLocation, showsUserLocation: true)
//                .ignoresSafeArea()
//            if locationViewModel.userHasLocation {
//                Text("Localizacion Aceptada ✅")
//                    .bold()
//                    .padding(.top, 12)
//            }
//            else {
//                Text("Localizacion Denegada ❌")
//                    .bold()
//                    .padding(.top, 12)
//            }
//            Link(
//                "Pulsa para cambiar la autorizacion de Localizacion",
//                destination: URL(string: UIApplication.openSettingsURLString)!
//            )
//            .padding(32)
//        }
        
        /*   MAGNIFICATIONGESTURE   */
        
//        NavigationView {
//            VStack {
//                Text("Scale \(scale)")
//                Text("Swift es una pasada!!")
//                    .bold()
//                    .padding()
//                    .foregroundStyle(Color.white)
//                    .frame(width: 360, height: 100)
//                    .background(Color.red)
//                    .cornerRadius(20)
//                    .scaleEffect(scale)
//                    .gesture(
//                        MagnificationGesture()
//                            .onChanged({ value in
//                                scale = value
//                            })
//                            .onEnded({ _ in
//                                withAnimation {
//                                    scale = 1.0
//                                }
//                            })
//                    )
//            }
//            .offset(y: -100)
//            .navigationTitle("Magnification Gesture")
//        }
        
        
        /*   LONGPRESSGESTURE   */
        
//        Text("Unete ya!!")
//            .padding()
//            .onLongPressGesture(minimumDuration: 3, maximumDistance: 50) {
//                print("Has mantenido pulsado!")
//            }
//
//        VStack {
//            Text("Manten pulsado para la magia")
//                .bold()
//                .multilineTextAlignment(.center)
//                .padding()
//            Rectangle()
//                .fill(self.isDetectingLongPress ? .green : .blue)
//                .gesture(longPress)
//            Spacer()
//        }
        
        /*   NAVIGATION STACK   */
        
//        NavigationStack(path: $path) {
//            Form {
//                Section {
//                    NavigationLink(developer.name, value: developer)
//                }
//                Section {
//                    List(fruits) { fruit in
//                        NavigationLink(fruit.name, value: fruit)
//                    }
//                    .navigationTitle("Fruits!")
//                }
//            }
//            .navigationDestination(for: Fruit.self) { fruit in
//                Text(fruit.name)
//            }
//            .navigationDestination(for: Developer.self) { developer in
//                VStack {
//                    Image(systemName: "laptopcomputer")
//                    Text(developer.name)
//                }
//                .font(.largeTitle)
//            }
//        }
//        .onAppear {
//            path = NavigationPath([fruits[7], fruits[0]])
//            path.append(developer)
//        }
        
        /*      GRID        */
        
//        VStack {
//
//            Grid() {
//                GridRow {
//                    Image(systemName: "figure.soccer")
//                    Text("Soccer")
//                }
//                Divider()
//                    .gridCellUnsizedAxes(.horizontal)
//                GridRow {
//                    Image(systemName: "figure.basketball")
//                    Text("Basketball")
//                }
//            }
//            .font(.largeTitle)
//
//            Spacer()
//
//            VStack {
//                HStack {
//                    Image(systemName: "figure.soccer")
//                    Text("Soccer")
//                }
//                Divider()
//                HStack {
//                    Image(systemName: "figure.basketball")
//                    Text("Basketball")
//                }
//            }
//            .font(.largeTitle)
//
//            Grid {
//                GridRow {
//                    Rectangle()
//                        .fill(.green.gradient)
//                        .gridCellColumns(2)
//                    Rectangle()
//                        .fill(.red.gradient)
//                }
//                GridRow {
//                    Rectangle()
//                        .fill(.blue.gradient)
//                    Rectangle()
//                        .fill(.purple.gradient)
//                }
//                GridRow {
//                    Rectangle()
//                        .fill(.yellow.gradient)
//                        .gridCellColumns(4)
//                }
//            }
//
//            Grid(horizontalSpacing: 20, verticalSpacing: 15) {
//                GridRow {
//                    Text("Fila 1")
//                    ForEach(0..<2) { _ in
//                        Circle().fill(.red.gradient)
//                    }
//                }
//                GridRow {
//                    Text("Fila 2")
//                    ForEach(0..<6) { _ in
//                        Circle().fill(.orange.gradient)
//                    }
//                }
//                GridRow {
//                    Text("Fila 3")
//                    ForEach(0..<4) { _ in
//                        Circle().fill(.purple.gradient)
//                    }
//                }
//                GridRow {
//                    Text("Fila 4")
//                    ForEach(0..<5) { _ in
//                        Circle().fill(.green.gradient)
//                    }
//                }
//            }
//            .frame(height: 200)
//            .padding(.horizontal)
//
//        }
        
        /*      REGEX       */
        
//        Form {
//            Section {
//                Text(regexText)
//            }
//            Button("Get Hashtags and Emails") {
//                checkHashtags()
//                checkEmails()
//            }
//            Section("HASHTAGS") {
//                Text(hashtags)
//            }
//            Section("EMAILS") {
//                Text(emails)
//            }
//        }
        
        /*  MULTIDATEPICKER Y SHARELINK */
        
//        Form {
//            MultiDatePicker(selection: $selectedDates, in: .now...) {
//                Label("Selecciona una fecha", systemImage: "calendar.badge.plus")
//            }
//            .frame(height: 200)
//            .onChange(of: selectedDates) {
//                  getDatesFormatted()
//            }
//            
//            Text(finalDates)
//            //Button("Aceptar") {
//            //    getDatesFormatted()
//            //}
//        }
//        ShareLink("Compartir", item: dateURL!, subject: Text("Mis fechas"), message: Text(finalDates))
     
        /*      SHEETS      */
        
//        VStack {
//            Text("SUSCRIBETE A SWIFT BETA!!!")
//                .font(isActive ? .largeTitle.weight(.heavy) : .headline)
//                .padding(isActive ? 20 : 0)
//                .background(isActive ? .orange : .clear)
//                .foregroundStyle(isActive ? Color(.systemBackground) : .green)
//                .cornerRadius(isActive ? 20 : 0)
//                .onTapGesture {
//                    withAnimation {
//                        isActive.toggle()
//                    }
//                }
//            Button("Open Sheet") {
//                showSheet.toggle()
//            }
//            .padding(.top, 32)
//        }
//        .sheet(isPresented: $showSheet) {
//            Text("Novedades en SwiftUI")
//                .presentationDetents([.fraction(0.2), .height(40), .medium, .large])
//                .presentationDragIndicator(.hidden)
//        }
        
        /*      GAUGE      */
        
//        Form {
//            
//            Section("Linear") {
//                Gauge(value: value) {
//                    Text("Value")
//                }
//                currentValueLabel: {
//                    Text(updateValueToString())
//                }
//                Gauge(value: value) {
//                    Text("Value")
//                }
//                currentValueLabel: {
//                    Text(updateValueToString())
//                }
//                .gaugeStyle(.accessoryLinear)
//                .tint(.red)
//                Gauge(value: value) {
//                    Text("Value")
//                }
//                currentValueLabel: {
//                    Text(updateValueToString())
//                }
//                .gaugeStyle(.accessoryLinearCapacity)
//                .tint(.green)
//            }
//            
//            Section("Circular") {
//                HStack {
//                    Gauge(value: value) {
//                        Text("Value")
//                    }
//                    currentValueLabel: {
//                        Text(updateValueToString())
//                    }
//                    .gaugeStyle(.accessoryCircular)
//                    .tint(.red)
//                    Gauge(value: value) {
//                        Text("Value")
//                    }
//                    currentValueLabel: {
//                        Text(updateValueToString())
//                    }
//                    .gaugeStyle(.accessoryCircularCapacity)
//                    .tint(.green)
//                }
//            }
//            
//            Section {
//                Slider(value: $value) {
//                    Text("\(Int(value * 100))%")
//                }
//                minimumValueLabel: {
//                    Text("0%")
//                }
//                maximumValueLabel: {
//                    Text("100%")
//                }
//            }
//            
//        }
        
        /*      PHOTOS PICKER      */
        
//        Form {
//            Section("Select Photo") {
//                VStack {
//                    ForEach(images) { image in
//                        image
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 120, height: 120)
//                    }
//                    Divider()
//                    PhotosPicker(selection: $photoSelecction, matching: .images, photoLibrary: .shared()) {
//                        Label("Selecciona una foto", systemImage: "photo.on.rectangle.angled")
//                    }
//                    .onChange(of: photoSelecction) { _, newItem in
//                        changeImage(newItem: newItem)
//                    }
//                }
//            }
//        }
        
        /*      SWIFT CHARTS      */
        
//        VStack {
//            
//            Chart(youtubeVideoModel) { data in
//                BarMark(
//                    x: .value("Date", data.date, unit: .day),
//                    y: .value("Views", data.views)
//                )
//                .annotation(position: .top, alignment: .center) {
//                    Text("\(data.views)")
//                }
//                RuleMark(y: .value("Average", viewsAverage))
//                    .foregroundStyle(.blue)
//                    .annotation(position: .top, alignment: .leading) {
//                        Label("\(Int(viewsAverage))", systemImage: "eye.fill")
//                            .foregroundStyle(Color(.blue))
//                            .font(.footnote)
//                    }
//            }
//            .chartXAxis {
//                AxisMarks(values: .stride(by: .day)) { day in
//                    AxisValueLabel(format: .dateTime.day(.defaultDigits))
//                    AxisTick()
//                    AxisGridLine()
//                }
//            }
//            .foregroundStyle(Color(.green))
//            .frame(height: 200)
//            
//            Chart {
//                ForEach(metrics) { metric in
//                    ForEach(metric.data) { data in
//                        if (metric.source == "YouTube") {
//                            BarMark(
//                                x: .value("Date", data.date, unit: .day),
//                                y: .value("Views", data.views)
//                            )
//                        }
//                        else {
//                            LineMark(
//                                x: .value("Date", data.date, unit: .day),
//                                y: .value("Views", data.views)
//                            )
//                            .symbol(by: .value("Value", metric.source))
//                        }
//                    }
//                    .foregroundStyle(by: .value("Axis", metric.source))
//                }
//            }
//            .frame(height: 200)
//            
//        }
        
        /*      REDACTED     */
        
//        VStack {
//            Text("Suscribete ahora!!")
//                .font(.title)
//            Text("Aprende a crear apps para iPhone")
//            Text("Swift, SwiftUI, y mucho más!")
//            HStack {
//                Image(systemName: "hand.thumbsup.circle.fill")
//                    .imageScale(.large)
//                    .foregroundStyle(Color.accentColor)
//                Image(systemName: "heart.circle.fill")
//                    .imageScale(.large)
//                    .foregroundStyle(Color.red)
//            }
//            .font(.largeTitle)
//            .padding(.top, 10)
//        }
//        .padding()
//        .redacted(reason: .placeholder)
        
        /*      MASK       */
        
//        VStack {
//            Rectangle()
//                .fill(.white)
//                .mask({
//                    Text("Mira aqui!!")
//                        .font(.system(size: 30, weight: .bold, design: .monospaced))
//                })
//                .frame(width: 300, height: 200)
//        }
//        .background(Color.blue)
//        .padding()
//        
//        ZStack {
//            Color.black.ignoresSafeArea()
//            ScrollView {
//                VStack {
//                    Rectangle()
//                        .fill(.black.gradient)
//                    Rectangle()
//                        .fill(.green.gradient)
//                    Rectangle()
//                        .fill(.blue.gradient)
//                    Rectangle()
//                        .fill(.purple.gradient)
//                    Rectangle()
//                        .fill(.black.gradient)
//                }
//                .frame(width: 800, height: 1000)
//                .offset(y: offsetY)
//            }
//            .mask({
//                Text("SWIFT")
//                    .font(.system(size: 50, weight: .bold, design: .monospaced))
//            })
//            .background(RadialGradient(gradient: gradient, center: .center, startRadius: 0, endRadius: 360 ))
//        }
//        .onAppear {
//            withAnimation(.linear(duration: 5).repeatForever(autoreverses: true)) {
//                offsetY = -500
//            }
//        }
        
        /*      OVERLAY     */
        
//        Circle()
//            .fill(.blue)
//            .frame(width: 300)
//            .overlay(alignment: .bottomTrailing) {
//                Button {
//                    print("Edit Profile Image")
//                } label: {
//                    HStack {
//                        Image(systemName: "pencil.circle.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .tint(.black)
//                            .frame(width: 70)
//                    }
//                }
//            }
//        ZStack {
//            RoundedRectangle(cornerRadius: 4)
//                .fill(.blue)
//                .overlay(alignment: .bottomTrailing) {
//                    Image(systemName: "figure.run")
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 100, height: 240)
//                        .offset(x: -40)
//                }
//            HStack {
//                VStack(alignment: .leading) {
//                    Text("SWIFTUI")
//                        .fontWidth(.compressed)
//                        .foregroundColor(.white)
//                        .font(.system(size: 80, weight: .bold))
//                        .padding(.bottom, -40)
//                    Text("¡SUSCRIBETE AL\nCANAL DE SWIFTBETA!")
//                        .multilineTextAlignment(.center)
//                        .fontWidth(.compressed)
//                        .foregroundColor(.orange)
//                        .font(.system(size: 26, weight: .bold))
//                        .frame(width: 200, height: 100)
//                    Spacer()
//                    Text("SWIFTBETA")
//                        .fontWidth(.standard)
//                        .foregroundColor(.white)
//                        .font(.system(size: 18, weight: .bold))
//                    HStack(alignment: .lastTextBaseline) {
//                        Image(systemName: "applelogo")
//                            .font(.footnote)
//                            .foregroundColor(.white)
//                        Text("Mobile Developer")
//                            .fontWidth(.standard)
//                            .foregroundColor(.white)
//                            .fontWeight(.regular)
//                            .font(.system(size: 14))
//                    }
//                }
//                .padding(.leading, 12)
//                .padding(.top, 6)
//                Spacer()
//            }
//        }
//        .frame(height: 230)
//        .padding(.horizontal, 12)
        
        /*    TOOLBAR   */
        
//        NavigationStack {
//            List(1..<50) { value in
//                Image(systemName: "globe")
//                    .imageScale(.large)
//                    .foregroundColor(.accentColor)
//                Text("Home")
//            }
//            .toolbar{
//                ToolbarItem {
//                    Button("Primary", action: {})
//                }
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    Button("Trailing", action: {})
//                }
//                ToolbarItem(placement: .navigationBarLeading) {
//                    Button("Leading", action: {})
//                }
//                ToolbarItem(placement: .confirmationAction) {
//                    Button("Confirm", action: {})
//                }
//                ToolbarItem(placement: .principal) {
//                    Button("Principal", action: {})
//                }
//            }
//            .toolbarBackground(.green, for: .navigationBar)
//            .toolbarBackground(.visible, for: .navigationBar)
//        }
        
        /*       SCANNER       */
        
//        ScanView(scanProvider: scanProvider)
//            .sheet(isPresented: $scanProvider.showSheet) {
//                VStack(alignment: .leading) {
//                    HStack {
//                        Spacer()
//                        Button(
//                            action: {
//                                scanProvider.speak()
//                            }
//                        ) {
//                            Label("Play", systemImage: "play.fill")
//                                .padding(.top, 20)
//                                .padding(.trailing, 20)
//                        }
//                    }
//                    Text(scanProvider.text)
//                        .font(.system(.body, design: .rounded))
//                        .padding(.top, 20)
//                        .padding(.horizontal, 20)
//                    Spacer()
//                }
//                .presentationDragIndicator(.visible)
//                .presentationDetents([.medium, .large])
//            }
        
        
        /*      DYNAMIC ISLAND      */
        
        VStack {
            Spacer()
            
            Text("¡Compra tu MacBook Pro!")
                .font(.system(size: 28, weight: .bold))
                .padding(.bottom, 32)
            
            Image(systemName: "macbook")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            
            Text(productName)
                .font(.system(.largeTitle))
            
            Text(currentDeliveryState.rawValue)
                .font(.system(.body))
            
            Button(action: {
                buyProduct()
            }) {
                Label("Comprar", systemImage: "cart.fill")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 32)
            
            Button(action: {
                
            }) {
                Label("Limpiar", systemImage: "paintbrush.fill")
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 32)
            .tint(.green)
            
            Spacer()
        }
        
    }
    
}

struct HomeView: View {
    
    var body: some View {
        VStack {
            Image(systemName: "house.fill")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            Text("Home")
                .padding(.top, 33)
        }
    }
    
}

struct ProfileView: View {
    
    var body: some View {
        Text("Profile")
    }
    
}

struct CounterView: View {
    
    @Binding var counter: Int
    
    var body: some View {
        
        VStack {
            Text("\(counter)")
                .font(.custom("SF Pro Rounded", size: 150))
                .bold()
            
            Spacer().frame(height: 100)
            
            Button("Sumar") {
                counter += 1
            }
            .buttonStyle(.borderedProminent)
            .font(.custom("SF Pro Rounded", size: 50))
        }
        
    }
}

struct ListVideosView: View {
    
    @ObservedObject var contentViewModel: ContentViewModel
    
    var body: some View {
        
        NavigationView {
            List(contentViewModel.videosModel, id: \.self) { video in
                Text("\(video)")
            }
            .navigationTitle("Videos")
            .toolbar() {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Añadir") {
                        contentViewModel.addMoreTopics()
                    }
                }
            }
        }

    }

}

struct View2: View {
    
    var body: some View {
        
        VStack {
            Text("Vista 2")
                .padding()
            View3()
        }

    }

}

struct View3: View {
    
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        
        VStack {
            Text("Vista 3")
                .padding()
            Button("Sumar") {
                viewModel.counter += 1
            }
        }

    }
    
}

final class ContentViewModel: ObservableObject {
    
    @Published var videosModel: [String] = []
    
    init() {
        videosModel = ["XCode", "Swift", "SwiftUI"]
    }
    
    
    func addMoreTopics() {
        videosModel.append("Kotlin")
    }

}

final class ViewModel: ObservableObject {
    @Published var counter: Int = 0
}

struct ButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.body)
            .foregroundStyle(Color(.white))
            .padding()
            .background(Color.blue)
            .cornerRadius(20)
    }
    
}

extension View {
    
    func buttonModifier() -> some View {
        self.modifier(ButtonModifier())
    }
    
}

struct CustomTitleView<Content: View>: View {
    
    @State private var title: String = "Navigation View"
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .bold()
            GeometryReader { proxy in
                ScrollView {
                    content
                }
            }
        }
        .onPreferenceChange(CustomTitleKey.self) { value in
            print("Value \(value)")
            title = value
        }
    }
    
}

struct CustomTitleKey: PreferenceKey {
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
//        if !value.isEmpty {
//            return
//        }
        value = value + " " + nextValue()
    }
    
}

final class LocationViewModel: NSObject, ObservableObject {
    
    private struct DefaultRegion {
        static let latitude = 9.9333
        static let longitude = -84.0833
    }
    
    private struct Span {
        static let delta = 0.8
    }
    
    @Published var userHasLocation: Bool = false
    
    @Published var userLocation: MKCoordinateRegion = .init()
    
    private let locationManager: CLLocationManager = .init()
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        userLocation = .init(center: .init(latitude: DefaultRegion.latitude, longitude: DefaultRegion.longitude), span: .init(latitudeDelta: Span.delta, longitudeDelta: Span.delta))
    }
    
    func checkUserAuthorization() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined, .restricted, .denied:
            userHasLocation = false
        case .authorizedAlways, .authorizedWhenInUse:
            userHasLocation = true
        @unknown default:
            print("Unhandled state")
        }
    }
    
}

extension LocationViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        print("Location \(location)")
        userLocation = .init(center: location.coordinate, span: .init(latitudeDelta: Span.delta, longitudeDelta: Span.delta))
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserAuthorization()
    }
    
}

extension Image: @retroactive Identifiable {
    public var id: String { UUID().uuidString }
}

struct ScanView: UIViewControllerRepresentable {
    @ObservedObject var scanProvider: ScanProvider
    
    func makeUIViewController(context: Context) -> some DataScannerViewController {
        let dataScannerViewController = DataScannerViewController(recognizedDataTypes: [.text()], qualityLevel: .fast, isHighlightingEnabled: true)
        
        dataScannerViewController.delegate = scanProvider
        try? dataScannerViewController.startScanning()
        
        return dataScannerViewController
    }
    
    func updateUIViewController(_ uiViewController: some UIViewController, context: Context) {
        
    }
}

final class ScanProvider: NSObject, DataScannerViewControllerDelegate, ObservableObject {
    @Published var text: String = ""
    @Published var error: DataScannerViewController.ScanningUnavailable?
    @Published var showSheet: Bool = false
    let synthesizer = AVSpeechSynthesizer()
    
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        switch item {
        case .text(let recognizedText):
            self.text = recognizedText.transcript
            self.showSheet.toggle()
            print(recognizedText)
        case .barcode(_):
            break
        @unknown default:
            break
        }
    }
    
    func dataScanner(_ dataScanner: DataScannerViewController, becameUnavailableWithError error: DataScannerViewController.ScanningUnavailable) {
        self.error = error
        print(error)
    }
    
    func speak() {
        let textCopy = text
        let utterance = AVSpeechUtterance(string: textCopy)
        utterance.voice = AVSpeechSynthesisVoice(language: "es-ES")
        
        synthesizer.pauseSpeaking(at: .word)
        synthesizer.speak(utterance)
    }
}

#Preview {
    ContentView()
}
