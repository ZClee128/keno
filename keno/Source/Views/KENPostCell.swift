import UIKit

protocol KENPostCellDelegate: AnyObject {
    func didTapUser(username: String, avatarURL: String)
    func didTapShare(post: KENPost, sourceView: UIView)
}

class KENPostCell: UICollectionViewCell {
    
    // UI Components
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = KENConstants.Colors.cardBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = KENConstants.Colors.shadow.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        return view
    }()
    
    // ... (Keep existing UI properties)
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 20
        iv.backgroundColor = KENConstants.Colors.sand
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = KENConstants.Fonts.title(size: 16)
        label.textColor = KENConstants.Colors.textPrimary
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = KENConstants.Fonts.caption()
        label.textColor = KENConstants.Colors.textSecondary
        return label
    }()
    
    private let postImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = KENConstants.Colors.background
        return iv
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = KENConstants.Fonts.body()
        label.textColor = KENConstants.Colors.textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private let likesLabel: UILabel = {
        let label = UILabel()
        label.font = KENConstants.Fonts.caption(size: 14)
        label.textColor = KENConstants.Colors.textPrimary
        return label
    }()
    
    // Action Buttons
    private let actionStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 16
        stack.alignment = .center
        return stack
    }()
    
    private func createActionButton(imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .semibold)
        button.setImage(UIImage(systemName: imageName, withConfiguration: config), for: .normal)
        button.tintColor = KENConstants.Colors.textPrimary
        return button
    }
    
    // Delegate
    weak var delegate: KENPostCellDelegate?
    private var post: KENPost?

    // Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        setupUI()
        setupGestures()
    }
    
    private func setupGestures() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapAvatar))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapAvatar() {
        guard let post = post else { return }
        delegate?.didTapUser(username: post.username, avatarURL: post.userAvatarURL)
    }
    
    @objc private func didTapShare(_ sender: UIButton) {
        guard let post = post else { return }
        delegate?.didTapShare(post: post, sourceView: sender)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(avatarImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(postImageView)
        containerView.addSubview(captionLabel)
        containerView.addSubview(actionStackView)
        containerView.addSubview(likesLabel)
        
        let likeButton = createActionButton(imageName: "heart")
        let commentButton = createActionButton(imageName: "bubble.right")
        let shareButton = createActionButton(imageName: "paperplane")
        shareButton.addTarget(self, action: #selector(didTapShare), for: .touchUpInside)
        
        actionStackView.addArrangedSubview(likeButton)
        actionStackView.addArrangedSubview(commentButton)
        actionStackView.addArrangedSubview(shareButton)
        actionStackView.addArrangedSubview(UIView()) // Spacers
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        actionStackView.translatesAutoresizingMaskIntoConstraints = false
        likesLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            avatarImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40),
            
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            timeLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            
            captionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 12),
            captionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            captionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            postImageView.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 12),
            postImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            postImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            postImageView.heightAnchor.constraint(equalToConstant: 250),
            
            actionStackView.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 12),
            actionStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            actionStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            actionStackView.heightAnchor.constraint(equalToConstant: 30),
            
            likesLabel.topAnchor.constraint(equalTo: actionStackView.bottomAnchor, constant: 12),
            likesLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            likesLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16)
        ])
    }
    
    func configure(with post: KENPost) {
        self.post = post
        nameLabel.text = post.username
        timeLabel.text = post.timestamp
        captionLabel.text = post.caption
        likesLabel.text = "\(post.likes) Likes"
        
        avatarImageView.image = nil // Reset
        postImageView.image = nil // Reset
        
        KENImageLoader.shared.loadImage(from: post.userAvatarURL) { [weak self] image in
            self?.avatarImageView.image = image
        }
        
        KENImageLoader.shared.loadImage(from: post.postImageURL) { [weak self] image in
            self?.postImageView.image = image
        }
    }
}
