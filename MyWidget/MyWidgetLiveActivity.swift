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
            HStack {
                Image(systemName: "box.truck.badge.clock.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.indigo)
                    .padding()
                VStack(alignment: .leading) {
                    Text("\(context.state.productName) está \(context.state.deliveryStatus.rawValue)")
                }
                Spacer()
                VStack(alignment: .center) {
                    Text("Hora de entrega")
                    Text(context.state.estimatedArrivalDate)
                        .bold()
                }
            }
            .activityBackgroundTint(.black)
            .activitySystemActionForegroundColor(.white)

        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "box.truck.badge.clock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 12)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text(context.state.productName)
                        .bold()
                        .multilineTextAlignment(.center)
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("Paquete: \(context.state.deliveryStatus.rawValue)")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Button(action: {}) {
                        Label("Cancelar", systemImage: "xmark.circle.fill")
                    }
                }
            } compactLeading: {
                    Image(systemName: "box.truck.badge.clock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                
            } compactTrailing: {
                Text(context.state.deliveryStatus.rawValue)
            } minimal: {
                Image(systemName: "box.truck.badge.clock.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.green)
            }

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
