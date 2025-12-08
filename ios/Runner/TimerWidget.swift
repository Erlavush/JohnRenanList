import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), title: "Assignment", deadline: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), title: "Math Final", deadline: Date().addingTimeInterval(3600))
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        // Fetch data from UserDefaults (shared group)
        let userDefaults = UserDefaults(suiteName: "group.com.johnrenan.johnRenanList")
        let title = userDefaults?.string(forKey: "title") ?? "No Assignments"
        let deadlineMillis = userDefaults?.double(forKey: "deadline") ?? 0
        
        let deadline = deadlineMillis > 0 ? Date(timeIntervalSince1970: deadlineMillis / 1000) : Date()
        
        // Refresh policy: Every 15 minutes is standard, but here we just show the timer counting down
        let entries = [SimpleEntry(date: Date(), title: title, deadline: deadline)]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let title: String
    let deadline: Date
}

struct TimerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Color(hex: "6c1606") // Deep Red Background
            
            VStack {
                Text(entry.title)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text(entry.deadline, style: .timer) // Logic: Built-in timer style
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundColor(Color(hex: "faf807")) // Neon Yellow
                    .multilineTextAlignment(.center)
            }
        }
    }
}

@main
struct TimerWidget: Widget {
    let kind: String = "TimerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            TimerWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Deadline Timer")
        .description("Shows the next deadline countdown.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
