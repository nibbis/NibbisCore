//
//  File.swift
//  File
//
//  Created by Chesley Stephens on 7/19/21.
//

import Foundation

public extension LocalStorage {
    
    static func userDefaults() -> Self {
        Self(
            save: { key, value in
                UserDefaults.standard.setValue(value, forKey: key)
            },
            get: { key in
                UserDefaults.standard.object(forKey: key) as? AnyHashable
            },
            observe: { key in
                var oldValue = UserDefaults.standard.object(forKey: key) as? AnyHashable
                
                return AsyncStream<AnyHashable?> { continuation in
                    continuation.yield(oldValue)
                    
                    NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: nil) { notification in
                        let newValue = UserDefaults.standard.object(forKey: key) as? AnyHashable
                        if oldValue != newValue {
                            continuation.yield(newValue)
                            oldValue = newValue
                        }
                    }
                }
            },
            remove: { key in
                UserDefaults.standard.removeObject(forKey: key)
            },
            removeAll: {
                if let domainName = Bundle.main.bundleIdentifier {
                    return UserDefaults.standard.removePersistentDomain(forName: domainName)
                }
                return
            }
        )
    }
}
