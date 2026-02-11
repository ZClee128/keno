import Foundation

class WLDCoinManager {
    static let shared = WLDCoinManager()
    
    // Simple key-value store
    private let key = "wldo_user_balance"
    
    var balance: Int {
        get {
            return UserDefaults.standard.integer(forKey: key)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
            NotificationCenter.default.post(name: NSNotification.Name("WLDCoinBalanceChanged"), object: nil)
        }
    }
    
    private init() {
        if UserDefaults.standard.object(forKey: key) == nil {
            balance = 100 // Initial bonus
        }
    }
    
    func addCoins(_ amount: Int) {
        balance += amount
    }
    
    func spendCoins(_ amount: Int) -> Bool {
        if balance >= amount {
            balance -= amount
            return true
        }
        return false
    }
}
