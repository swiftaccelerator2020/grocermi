//
//  GrocermiWidgetExtension.swift
//  GrocermiWidgetExtension
//
//  Created by Joshua Lim on 8/12/20.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [SimpleEntry(date: Date())]
        let timeline = Timeline(entries: entries, policy: .never)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct GrocermiWidgetExtensionEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                Text("Grocery List")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Text("!")
            }
            HStack {
                VStack(alignment: .leading, spacing: 2.0) {
                    Text("egg")
                    Text("egg")
                    Text("egg")
                    Text("egg")
                    Text("egg")
                }
                .padding(.trailing, 60.0)
                Divider()
                VStack(alignment: .leading, spacing: 2.0) {
                    Text("1")
                    Text("2")
                    Text("3")
                    Text("4")
                    Text("5")
                }
            }
        }
    }
}

@main
struct GrocermiWidgetExtension: Widget {
    let kind: String = "GrocermiWidgetExtension"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            GrocermiWidgetExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct GrocermiWidgetExtension_Previews: PreviewProvider {
    static var previews: some View {
        GrocermiWidgetExtensionEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
