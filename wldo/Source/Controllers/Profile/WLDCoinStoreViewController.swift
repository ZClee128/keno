import UIKit
import StoreKit

class WLDCoinStoreViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var collectionView: UICollectionView!
    // Product map to display specific coin amount and format
    private let productMap: [String: Int] = [
        "Keno": 32,
        "Keno1": 60,
        "Keno2": 96,
        "Keno4": 155,
        "Keno5": 189,
        "Keno9": 359,
        "Keno19": 729,
        "Keno49": 1869,
        "Keno99": 3799
    ]
    
    private var availableProducts: [SKProduct] = []
    
    // Ordered fallback list shown if StoreKit can't load (simulator/offline)
    private let fallbackPackages: [(coins: Int, price: String, id: String)] = [
        (32,   "$0.99",  "Keno"),
        (60,   "$1.99",  "Keno1"),
        (96,   "$2.99",  "Keno2"),
        (155,  "$4.99",  "Keno4"),
        (189,  "$5.99",  "Keno5"),
        (359,  "$9.99",  "Keno9"),
        (729,  "$19.99", "Keno19"),
        (1869, "$49.99", "Keno49"),
        (3799, "$99.99", "Keno99")
    ]
    
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = WLDAppConfig.Fonts.header(size: 32)
        label.textColor = WLDAppConfig.Colors.lifestyleAccent
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Coin Store"
        view.backgroundColor = WLDAppConfig.Colors.background
        setupUI()
        updateBalance()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateBalance), name: NSNotification.Name("WLDCoinBalanceChanged"), object: nil)
        
        loadProducts()
    }
    
    private func loadProducts() {
        WLDIAPManager.shared.onProductsFetched = { [weak self] products in
            self?.availableProducts = products
            self?.collectionView.reloadData()
        }
        
        WLDIAPManager.shared.onPurchaseSuccess = { [weak self] productId in
            if let amount = self?.productMap[productId] {
                // Add coins locally
                WLDCoinManager.shared.addCoins(amount)
            }
        }
        
        WLDIAPManager.shared.onPurchaseFailure = { error in
            print("Purchase failed: \(String(describing: error?.localizedDescription))")
        }
        
        WLDIAPManager.shared.fetchProducts()
    }
    
    @objc private func updateBalance() {
        balanceLabel.text = "🪙 \(WLDCoinManager.shared.balance)"
    }
    
    private func setupUI() {
        // Balance label at top
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(balanceLabel)
        
        // Collection view below balance label, fills remaining space
        let layout = createLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false // One-page, no scroll
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(WLDCoinCell.self, forCellWithReuseIdentifier: "CoinCell")
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    private func createLayout() -> UICollectionViewLayout {
        // 3 columns × 3 rows to fit 9 packages on one screen
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item, item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 10, bottom: 8, trailing: 10)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableProducts.isEmpty ? fallbackPackages.count : availableProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CoinCell", for: indexPath) as! WLDCoinCell
        
        if availableProducts.isEmpty {
            // Fallback: display static list
            let pkg = fallbackPackages[indexPath.item]
            cell.configure(amount: pkg.coins, price: pkg.price)
        } else {
            let product = availableProducts[indexPath.item]
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = product.priceLocale
            let priceStr = formatter.string(from: product.price) ?? "$0.00"
            let coins = productMap[product.productIdentifier] ?? 0
            cell.configure(amount: coins, price: priceStr)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if availableProducts.isEmpty {
            // Products not yet loaded: attempt direct payment by product ID
            let pkg = fallbackPackages[indexPath.item]
            guard SKPaymentQueue.canMakePayments() else { return }
            let payment = SKMutablePayment()
            payment.productIdentifier = pkg.id
            SKPaymentQueue.default().add(payment)
        } else {
            let product = availableProducts[indexPath.item]
            WLDIAPManager.shared.purchase(product: product)
        }
    }
}

class WLDCoinCell: UICollectionViewCell {
    private let container = UIView()
    private let titleLabel = UILabel()
    private let priceButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(container)
        container.pin(to: contentView)
        container.backgroundColor = WLDAppConfig.Colors.cardBackground
        container.layer.cornerRadius = 16
        
        container.addSubview(titleLabel)
        container.addSubview(priceButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = WLDAppConfig.Fonts.header(size: 24)
        titleLabel.textColor = WLDAppConfig.Colors.textPrimary
        
        priceButton.translatesAutoresizingMaskIntoConstraints = false
        priceButton.setTitleColor(.white, for: .normal)
        priceButton.backgroundColor = WLDAppConfig.Colors.lifestyleAccent
        priceButton.layer.cornerRadius = 20
        priceButton.isUserInteractionEnabled = false // Tap cell instead
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor, constant: -20),
            
            priceButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            priceButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            priceButton.widthAnchor.constraint(equalToConstant: 100),
            priceButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(amount: Int, price: String) {
        titleLabel.text = "\(amount) coins"
        priceButton.setTitle(price, for: .normal)
    }
}

// MARK: - IAP Manager

class WLDIAPManager: NSObject {
    static let shared = WLDIAPManager()
    
    // As requested from the screenshot
    private let productIdentifiers: Set<String> = [
        "Keno",    // 32 coins
        "Keno1",   // 60 coins
        "Keno2",   // 96 coins
        "Keno4",   // 155 coins
        "Keno5",   // 189 coins
        "Keno9",   // 359 coins
        "Keno19",  // 729 coins
        "Keno49",  // 1869 coins
        "Keno99"   // 3799 coins
    ]
    
    // Callbacks
    var onProductsFetched: (([SKProduct]) -> Void)?
    var onPurchaseSuccess: ((String) -> Void)?
    var onPurchaseFailure: ((Error?) -> Void)?
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    func fetchProducts() {
        let request = SKProductsRequest(productIdentifiers: productIdentifiers)
        request.delegate = self
        request.start()
    }
    
    func purchase(product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            onPurchaseFailure?(nil)
            return
        }
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
}

extension WLDIAPManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // Sort by price
        let products = response.products.sorted { $0.price.decimalValue < $1.price.decimalValue }
        DispatchQueue.main.async {
            self.onProductsFetched?(products)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.onProductsFetched?([])
        }
    }
}

extension WLDIAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.onPurchaseSuccess?(transaction.payment.productIdentifier)
                }
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                DispatchQueue.main.async {
                    self.onPurchaseFailure?(transaction.error)
                }
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
            case .deferred, .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
}
