import UIKit

class WLDChatListCell: UITableViewCell {
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = WLDAppConfig.Colors.sand
        iv.layer.cornerRadius = 25
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = WLDAppConfig.Fonts.title(size: 16)
        label.textColor = WLDAppConfig.Colors.textPrimary
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = WLDAppConfig.Fonts.body(size: 14)
        label.textColor = WLDAppConfig.Colors.textSecondary
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = WLDAppConfig.Fonts.caption(size: 12)
        label.textColor = .systemGray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(messageLabel)
        addSubview(timeLabel)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 50),
            avatarImageView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            
            messageLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            timeLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    func configure(name: String, message: String, time: String) {
        nameLabel.text = name
        messageLabel.text = message
        timeLabel.text = time
        
        // Map username to proper avatar resource
        let avatarName: String
        switch name.lowercased() {
        case "reptilefan": avatarName = "avatar_reptilefan"
        case "snake", "snakewhisperer": avatarName = "avatar_snake"
        case "turtlepower": avatarName = "avatar_turtlepower"
        case "chameleoncham": avatarName = "avatar_chameleoncham"
        case "beardedbuddy": avatarName = "avatar_beardedbuddy"
        case "iguanaiggy": avatarName = "avatar_iguanaiggy"
        case "frogprince": avatarName = "avatar_frogprince"
        case "dinodan": avatarName = "avatar_dinodan"
        case "scalysue": avatarName = "avatar_scalysue"
        case "koboldkeeper": avatarName = "avatar_koboldkeeper"
        case "komodoking": avatarName = "avatar_komodoking"
        case "gatorgary": avatarName = "avatar_gatorgary"
        case "vipervicky": avatarName = "avatar_vipervicky"
        case "axolotlally": avatarName = "avatar_axolotlally"
        default: avatarName = "avatar_default"
        }
        
        WLDBitmapFetcher.shared.loadImage(from: avatarName) { [weak self] image in
            self?.avatarImageView.image = image
        }
    }
}
