import UIKit

class WLDEventDetailViewController: UIViewController {
    
    var event: WLDEvent!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let heroImageView = UIImageView()
    private let textContainer = UIView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationLabel = UILabel()
    private let attendeesLabel = UILabel()
    private let descLabel = UILabel()
    private let addToCalendarButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WLDAppConfig.Colors.background
        navigationItem.largeTitleDisplayMode = .never
        
        setupUI()
        populateData()
    }
    
    private func setupUI() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true
        heroImageView.backgroundColor = WLDAppConfig.Colors.sand
        contentView.addSubview(heroImageView)
        
        textContainer.translatesAutoresizingMaskIntoConstraints = false
        textContainer.backgroundColor = WLDAppConfig.Colors.cardBackground
        textContainer.layer.cornerRadius = 24
        textContainer.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        contentView.addSubview(textContainer)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = WLDAppConfig.Fonts.title(size: 28)
        nameLabel.textColor = WLDAppConfig.Colors.textPrimary
        nameLabel.numberOfLines = 0
        textContainer.addSubview(nameLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = WLDAppConfig.Fonts.title(size: 16)
        dateLabel.textColor = .systemOrange
        textContainer.addSubview(dateLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = WLDAppConfig.Fonts.body(size: 16)
        locationLabel.textColor = WLDAppConfig.Colors.textSecondary
        textContainer.addSubview(locationLabel)
        
        attendeesLabel.translatesAutoresizingMaskIntoConstraints = false
        attendeesLabel.font = WLDAppConfig.Fonts.caption(size: 14)
        attendeesLabel.textColor = WLDAppConfig.Colors.textSecondary
        textContainer.addSubview(attendeesLabel)
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = WLDAppConfig.Fonts.body(size: 16)
        descLabel.textColor = WLDAppConfig.Colors.textPrimary
        descLabel.numberOfLines = 0
        textContainer.addSubview(descLabel)
        
        addToCalendarButton.translatesAutoresizingMaskIntoConstraints = false
        addToCalendarButton.setTitle("Add to Calendar", for: .normal)
        addToCalendarButton.setTitleColor(WLDAppConfig.Colors.primaryButtonText, for: .normal)
        addToCalendarButton.backgroundColor = WLDAppConfig.Colors.primaryAction
        addToCalendarButton.titleLabel?.font = WLDAppConfig.Fonts.title(size: 18)
        addToCalendarButton.layer.cornerRadius = 25
        addToCalendarButton.addTarget(self, action: #selector(didTapCalendar), for: .touchUpInside)
        textContainer.addSubview(addToCalendarButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: 350),
            
            textContainer.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: -30),
            textContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            textContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            textContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: textContainer.topAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 12),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 6),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            attendeesLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 6),
            attendeesLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            descLabel.topAnchor.constraint(equalTo: attendeesLabel.bottomAnchor, constant: 20),
            descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor),
            
            addToCalendarButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 40),
            addToCalendarButton.leadingAnchor.constraint(equalTo: textContainer.leadingAnchor, constant: 20),
            addToCalendarButton.trailingAnchor.constraint(equalTo: textContainer.trailingAnchor, constant: -20),
            addToCalendarButton.heightAnchor.constraint(equalToConstant: 50),
            addToCalendarButton.bottomAnchor.constraint(equalTo: textContainer.bottomAnchor, constant: -40)
        ])
    }
    
    private func populateData() {
        guard let post = event else { return }
        nameLabel.text = post.name
        dateLabel.text = "🗓 \(post.date)"
        locationLabel.text = "📍 Venue: \(post.location)"
        attendeesLabel.text = "👥 Expected attendees: \(post.attendees)"
        descLabel.text = post.description
        
        WLDBitmapFetcher.shared.loadImage(from: post.imageName) { [weak self] img in
            self?.heroImageView.image = img
        }
    }
    
    @objc private func didTapCalendar() {
        let alert = UIAlertController(title: "Success", message: "\(event.name) has been added to your system calendar.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Awesome", style: .default, handler: { [weak self] _ in
            self?.addToCalendarButton.setTitle("Added \u{2713}", for: .normal)
            self?.addToCalendarButton.backgroundColor = .systemGreen
            self?.addToCalendarButton.isEnabled = false
        }))
        self.present(alert, animated: true)
    }
}
