//
//  Complication.swift
//  Complication
//
//  Created by Elliot Schrock on 10/7/23.
//  Copyright © 2023 Elliot Schrock. All rights reserved.
//

import WidgetKit
import SwiftUI
import UIKit

@available(watchOSApplicationExtension 10.0, *)
struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }

    func recommendations() -> [AppIntentRecommendation<ConfigurationAppIntent>] {
        // Create an array with all the preconfigured widgets to show.
        [AppIntentRecommendation(intent: ConfigurationAppIntent(), description: "Open Roost Remote")]
    }
}

@available(watchOSApplicationExtension 10.0, *)
struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

@available(watchOSApplicationExtension 10.0, *)
struct ComplicationEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        HStack {
            Image(systemName: "play.fill").padding()
        }.padding()
            .background(Circle().stroke(Color.primary))
        .containerBackground(for: .widget, content: {
            Circle().stroke(Color.primary)
        })
             .widgetAccentable(true)
             .unredacted()
    }
}

@available(watchOSApplicationExtension 10.0, *)
@main
struct Complication: Widget {
    let kind: String = "Complication"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            ComplicationEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

@available(watchOSApplicationExtension 10.0, *)
extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

//#Preview(as: .accessoryRectangular) {
//    if #available(watchOSApplicationExtension 10.0, *) {
//        Complication()
//    } else {
//        // Fallback on earlier versions
//    }
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}    
