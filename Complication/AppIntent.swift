//
//  AppIntent.swift
//  Complication
//
//  Created by Elliot Schrock on 10/7/23.
//  Copyright © 2023 Elliot Schrock. All rights reserved.
//

import WidgetKit
import AppIntents

@available(watchOSApplicationExtension 10.0, *)
struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "Favorite Emoji", default: "😃")
    var favoriteEmoji: String
}
