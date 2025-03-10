/*
Abstract:
The Entry content for a volume.
*/

import SwiftUI

struct Entry: View {
    @ObservedObject var eventHandler = EventHandler.shared
    @Binding var settings: GlobalSettings
    @Environment(\.scenePhase) private var scenePhase
    let saveAction: ()->Void

    var body: some View {
        VStack {
            Text("ALVR")
                .font(.system(size: 50, weight: .bold))
                .padding()
            
            Text("Options:")
                .font(.system(size: 20, weight: .bold))
            VStack {
                Toggle(isOn: $settings.showHandsOverlaid) {
                    Text("Show hands overlaid")
                }
                .toggleStyle(.switch)
                
                Toggle(isOn: $settings.keepSteamVRCenter) {
                    Text("Crown Button long-press also recenters SteamVR")
                }
                .toggleStyle(.switch)
            }
            .frame(width: 450)
            .padding()
            
            Text("Connection Information:")
                .font(.system(size: 20, weight: .bold))
            
            if eventHandler.hostname != "" && eventHandler.IP != "" {
                let columns = [
                    GridItem(.fixed(100), alignment: .trailing),
                    GridItem(.fixed(150), alignment: .leading)
                ]

                LazyVGrid(columns: columns) {
                    Text("hostname:")
                    Text(eventHandler.hostname)
                    Text("IP:")
                    Text(eventHandler.IP)
                }
                .frame(width: 250, alignment: .center)
            }
        }
        .frame(minWidth: 650, minHeight: 500)
        .glassBackgroundEffect()
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .background:
                saveAction()
                break
            case .inactive:
                saveAction()
                break
            case .active:
                break
            @unknown default:
                break
            }
        }
        
        EntryControls(saveAction: saveAction)
    }
}

struct Entry_Previews: PreviewProvider {
    static var previews: some View {
        Entry(settings: .constant(GlobalSettings.sampleData), saveAction: {})
    }
}
