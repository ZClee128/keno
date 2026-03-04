import UIKit

class WLDProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About Keno"
        view.backgroundColor = WLDAppConfig.Colors.background
        
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .singleLine
        
        // Register cells
        tableView.register(WelcomeCardCell.self, forCellReuseIdentifier: WelcomeCardCell.identifier)
        tableView.register(InfoCardCell.self, forCellReuseIdentifier: InfoCardCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BasicCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // MARK: - TableView
    func numberOfSections(in tableView: UITableView) -> Int { return 3 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1 // Welcome
        case 1: return 4 // App Info + Coin Store
        case 2: return 2 // Legal
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1: return "App Information"
        case 2: return "Legal & Support"
        default: return nil
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: WelcomeCardCell.identifier, for: indexPath) as! WelcomeCardCell
            return cell
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: InfoCardCell.identifier, for: indexPath) as! InfoCardCell
            if indexPath.row == 0 {
                cell.configure(title: "Coin Store & IAP", value: "Recharge", hasDisclosure: true, icon: "bitcoinsign.circle.fill", iconColor: .systemYellow)
            } else if indexPath.row == 1 {
                cell.configure(title: "Active Creators", value: "2,408", hasDisclosure: false, icon: "person.2.fill", iconColor: .systemTeal)
            } else if indexPath.row == 2 {
                cell.configure(title: "Featured Masterpieces", value: "11,592", hasDisclosure: false, icon: "photo.on.rectangle.angled", iconColor: .systemIndigo)
            } else {
                cell.configure(title: "Trending Tags", value: "348", hasDisclosure: false, icon: "chart.line.uptrend.xyaxis", iconColor: .systemOrange)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            if indexPath.row == 0 {
                cell.textLabel?.text = "Privacy Policy"
                cell.imageView?.image = UIImage(systemName: "hand.raised.fill")
                cell.imageView?.tintColor = .systemGray
            } else {
                cell.textLabel?.text = "Terms of Service"
                cell.imageView?.image = UIImage(systemName: "doc.text.fill")
                cell.imageView?.tintColor = .systemGray
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 2 {
            let type: WLDPolicyType = (indexPath.row == 0) ? .privacy : .terms
            let vc = WLDPolicyViewController(type: type)
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true)
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = WLDCoinStoreViewController()
                vc.hidesBottomBarWhenPushed = true
                navigationController?.pushViewController(vc, animated: true)
            } else {
                let titles = ["Active Creators", "Featured Masterpieces", "Trending Tags"]
                let messages = [
                    "Join our growing community of 2,408 talented cosplay creators from all over the world!",
                    "Explore 11,592 stunning pieces of high-quality cosplay photography hand-picked by our editors.",
                    "Dive into 348 active trending topics and find your favorite fandoms easily."
                ]
                let alert = UIAlertController(title: titles[indexPath.row - 1], message: messages[indexPath.row - 1], preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Awesome", style: .default))
                present(alert, animated: true)
            }
        }
    }
}

// MARK: - Custom Cells
class WelcomeCardCell: UITableViewCell {
    static let identifier = "WelcomeCardCell"
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = WLDAppConfig.Colors.cardBackground
        
        titleLabel.text = "Keno Platform"
        titleLabel.font = WLDAppConfig.Fonts.header(size: 22)
        titleLabel.textColor = WLDAppConfig.Colors.textPrimary
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        subtitleLabel.text = "The premier destination for high-quality Cosplay visual arts."
        subtitleLabel.numberOfLines = 0
        subtitleLabel.font = WLDAppConfig.Fonts.body(size: 14)
        subtitleLabel.textColor = WLDAppConfig.Colors.textSecondary
        subtitleLabel.textAlignment = .center
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            subtitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -32)
        ])
    }
}

class InfoCardCell: UITableViewCell {
    static let identifier = "InfoCardCell"
    
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = WLDAppConfig.Colors.cardBackground
        
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(iconImageView)
        
        titleLabel.font = WLDAppConfig.Fonts.body(size: 16)
        titleLabel.textColor = WLDAppConfig.Colors.textPrimary
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        valueLabel.font = WLDAppConfig.Fonts.header(size: 16)
        valueLabel.textColor = WLDAppConfig.Colors.textSecondary
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(valueLabel)
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 24),
            iconImageView.heightAnchor.constraint(equalToConstant: 24),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            valueLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50)
        ])
    }
    
    func configure(title: String, value: String, hasDisclosure: Bool, icon: String, iconColor: UIColor) {
        titleLabel.text = title
        valueLabel.text = value
        accessoryType = hasDisclosure ? .disclosureIndicator : .none
        
        iconImageView.image = UIImage(systemName: icon)
        iconImageView.tintColor = iconColor
        
        if hasDisclosure {
            valueLabel.textColor = WLDAppConfig.Colors.lifestyleAccent
        } else {
            valueLabel.textColor = WLDAppConfig.Colors.textSecondary
        }
    }
}
