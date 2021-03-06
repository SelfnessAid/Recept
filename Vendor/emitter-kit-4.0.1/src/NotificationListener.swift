
import Foundation

class NotificationListener : Listener {
  
  let name: String
  
  var observer: NSObjectProtocol!

  override func startListening() {
    observer = NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: name), object: nil, queue: nil, using: {
      [unowned self] in
      if self.targetID == getHash($0.object as AnyObject) {
        self.trigger(($0 as NSNotification).userInfo)
      }
    })
    
    var targets = NotificationListenerCache[name] ?? [:]
    var listeners = targets[targetID] ?? [:]
    listeners[getHash(self)] = once ? StrongPointer(self) : WeakPointer(self)
    targets[targetID] = listeners
    NotificationListenerCache[name] = targets
  }
  
  override func stopListening() {
    NotificationCenter.default.removeObserver(observer)
    
    var targets = NotificationListenerCache[name]!
    var listeners = targets[targetID]!
    listeners[getHash(self)] = nil
    targets[targetID] = listeners.nilIfEmpty
    NotificationListenerCache[name] = targets.nilIfEmpty
  }
  
  init (_ name: String, _ target: AnyObject!, _ handler: @escaping (NSDictionary) -> Void, _ once: Bool) {
    self.name = name
    super.init(target, { handler(($0 as? NSDictionary) ?? [:]) }, once)
  }
}

// 1 - Listener.name
// 2 - getHash(Listener.target)
// 3 - getHash(Listener)
// 4 - DynamicPointer<Listener>
var NotificationListenerCache = [String:[String:[String:DynamicPointer<Listener>]]]()
