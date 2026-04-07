//
//  MyWidgetLiveActivity.swift
//  MyWidget
//
//  Created by JuanDa on 7/4/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

@main
struct MyWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DeliveryAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello ")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom ")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T ")
            } minimal: {
                Text("context.state.emoji")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension DeliveryAttributes {
    fileprivate static var preview: DeliveryAttributes {
        DeliveryAttributes()
    }
}

//extension MyWidgetAttributes.ContentState {
//    fileprivate static var smiley: DeliveryAttributes.ContentState {
//        DeliveryAttributes.ContentState(emoji: "😀")
//     }
//     
//     fileprivate static var starEyes: DeliveryAttributes.ContentState {
//         DeliveryAttributes.ContentState(emoji: "🤩")
//     }
//}

#Preview("Compact", as: .dynamicIsland(.compact), using: DeliveryAttributes.preview) {
   MyWidgetLiveActivity()
} contentStates: {
    DeliveryAttributes.ContentState(deliveryStatus: .sent, productName: "MacBook Pro 1900€", estimatedArrivalDate: "21:00")
}

#Preview("Expanded", as: .dynamicIsland(.expanded), using: DeliveryAttributes.preview) {
   MyWidgetLiveActivity()
} contentStates: {
    DeliveryAttributes.ContentState(deliveryStatus: .sent, productName: "MacBook Pro 1900€", estimatedArrivalDate: "21:00")
}

#Preview("Minimal", as: .dynamicIsland(.minimal), using: DeliveryAttributes.preview) {
   MyWidgetLiveActivity()
} contentStates: {
    DeliveryAttributes.ContentState(deliveryStatus: .sent, productName: "MacBook Pro 1900€", estimatedArrivalDate: "21:00")
}

#Preview("Notification", as: .content, using: DeliveryAttributes.preview) {
   MyWidgetLiveActivity()
} contentStates: {
    DeliveryAttributes.ContentState(deliveryStatus: .sent, productName: "MacBook Pro 1900€", estimatedArrivalDate: "21:00")
}
