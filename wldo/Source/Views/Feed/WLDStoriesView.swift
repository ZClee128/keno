import UIKit

protocol WLDStoriesViewDelegate: AnyObject {
    func didSelectStory(name: String, isMyStory: Bool)
}

class WLDStoriesView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {
    
    weak var delegate: WLDStoriesViewDelegate?
    private var collectionView: UICollectionView!
    private let stories = ["ReptileFan", "Snake", "ChameleonCham", "TurtlePower", "BeardedBuddy"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(WLDStoryCell.self, forCellWithReuseIdentifier: "WLDStoryCell")
        
        addSubview(collectionView)
        collectionView.pin(to: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WLDStoryCell", for: indexPath) as! WLDStoryCell
        cell.configure(name: stories[indexPath.row], isMyStory: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let name = stories[indexPath.row]
        delegate?.didSelectStory(name: name, isMyStory: false)
    }
}

class WLDStoryCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 32
        iv.layer.borderWidth = 3
        iv.layer.borderColor = WLDAppConfig.Colors.reptileGreen.cgColor
        iv.backgroundColor = WLDAppConfig.Colors.sand
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = WLDAppConfig.Fonts.caption(size: 11)
        label.textColor = WLDAppConfig.Colors.textPrimary
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(nameLabel)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            imageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 64),
            imageView.heightAnchor.constraint(equalToConstant: 64),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 4),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String, isMyStory: Bool) {
        nameLabel.text = name
        if isMyStory {
            imageView.layer.borderColor = UIColor.systemGray4.cgColor // Or different color for "Add Story"
            // Placeholder for "Add"
            imageView.image = UIImage(systemName: "plus")
            imageView.tintColor = .gray
            imageView.contentMode = .center
        } else {
            imageView.layer.borderColor = WLDAppConfig.Colors.reptileGreen.cgColor
            imageView.contentMode = .scaleAspectFill // Use local avatar instead of external API
             WLDBitmapFetcher.shared.loadImage(from: "avatar_\(name.lowercased())") { [weak self] image in
                self?.imageView.image = image
            }
        }
    }
}
