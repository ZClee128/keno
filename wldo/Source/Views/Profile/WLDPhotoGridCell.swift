import UIKit

class WLDPhotoGridCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = WLDAppConfig.Colors.sand
        return iv
    }()
    
    private let playIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "play.fill")
        iv.tintColor = .white
        iv.contentMode = .scaleAspectFit
        iv.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        iv.layer.cornerRadius = 15
        iv.clipsToBounds = true
        iv.isHidden = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(playIconImageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        playIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            playIconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            playIconImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            playIconImageView.widthAnchor.constraint(equalToConstant: 30),
            playIconImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with post: WLDArticle) {
        imageView.image = nil
        playIconImageView.isHidden = post.videoName == nil
        
        WLDBitmapFetcher.shared.loadImage(from: post.postImageURL) { [weak self] image in
            self?.imageView.image = image
        }
    }
}
