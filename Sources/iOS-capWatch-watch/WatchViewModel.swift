 

import Foundation
import WatchConnectivity
import SwiftUI

public class WatchViewModel: NSObject, WCSessionDelegate, ObservableObject {
    public func sessionDidBecomeInactive(_ session: WCSession) {
        }
    
    public func sessionDidDeactivate(_ session: WCSession) {
     }
    
    var session: WCSession
    
    public static var shared = WatchViewModel()
    
    @AppStorage(SAVEDUI_KEY) var savedUI: String = ""
    
    @Published var watchUI = "Text(\"Capacitor WATCH\")\nButton(\"Add One\", \"inc\")"
    @Published var viewData: [String: String]?
    
    init(session: WCSession = .default, viewData: [String: String]? = nil) {
        self.session = session
        self.viewData = viewData
        
        super.init()
        
        if savedUI != "" {
            self.watchUI = self.savedUI
        }
    }
    
    public func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // apple docs say this won't work on simulator
        
        if WatchViewModel.shared.watchUI.isEmpty {
            let _ = session.transferUserInfo(REQUESTUI)
        }
    }
    
    public func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        handlePhoneMessage(message)
    }
    
    public func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        handlePhoneMessage(applicationContext)
    }
    
    public func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        handlePhoneMessage(userInfo)
    }
    
    // required protocol stubs?
    //func sessionDidBecomeInactive(_ session: WCSession) {}
    
    //func sessionDidDeactivate(_ session: WCSession) {}
    
    func handlePhoneMessage(_ userInfo: [String: Any]) {
        DispatchQueue.main.async {
            if let newUI = userInfo[UI_KEY] as? String {
                self.watchUI = newUI
                print("new watchUI: \(self.watchUI)")
                self.savedUI = self.watchUI
            }
            
            if let newViewData = userInfo[DATA_KEY] as? [String: String] {
                self.viewData = newViewData
            }
        }
    }
}
