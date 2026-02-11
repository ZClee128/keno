import UIKit

class WLDProfileHeaderView: UIView {
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = WLDAppConfig.Colors.sand
        iv.layer.cornerRadius = 40
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let postsCountLabel = UILabel()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = WLDAppConfig.Fonts.header(size: 20)
        label.textColor = WLDAppConfig.Colors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = WLDAppConfig.Fonts.body(size: 14)
        label.textColor = WLDAppConfig.Colors.textSecondary
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()
    
    private let statsStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = WLDAppConfig.Colors.cardBackground
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(avatarImageView)
        addSubview(nameLabel)
        addSubview(bioLabel)
        addSubview(statsStackView)
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            avatarImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            bioLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            bioLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            
            statsStackView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 20),
            statsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            statsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            statsStackView.heightAnchor.constraint(equalToConstant: 50),
            statsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
        
        setupStats()
    }
    
    private func setupStats() {
        let postsStat = createStatView(count: "0", title: "Posts", customLabel: postsCountLabel)
        let followersStat = createStatView(count: "0", title: "Followers")
        let followingStat = createStatView(count: "0", title: "Following")
        
        statsStackView.addArrangedSubview(postsStat)
        statsStackView.addArrangedSubview(followersStat)
        statsStackView.addArrangedSubview(followingStat)
    }
    
    private func createStatView(count: String, title: String, customLabel: UILabel? = nil) -> UIView {
        let view = UIView()
        let countLabel = customLabel ?? UILabel()
        countLabel.text = count
        countLabel.font = WLDAppConfig.Fonts.title(size: 16)
        countLabel.textColor = WLDAppConfig.Colors.textPrimary
        countLabel.textAlignment = .center
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = WLDAppConfig.Fonts.caption(size: 12)
        titleLabel.textColor = WLDAppConfig.Colors.textSecondary
        titleLabel.textAlignment = .center
        
        view.addSubview(countLabel)
        view.addSubview(titleLabel)
        
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: view.topAnchor),
            countLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 4),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func configure(name: String, bio: String, avatarURL: String, postCount: Int) {
        nameLabel.text = name
        bioLabel.text = bio
        postsCountLabel.text = "\(postCount)"
        WLDBitmapFetcher.shared.loadImage(from: avatarURL) { [weak self] image in
            self?.avatarImageView.image = image
        }
    }
}
