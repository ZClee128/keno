import UIKit
import EventKit

// MARK: - Event Model
struct WLDEvent {
    let name: String
    let date: String
    let location: String
    let description: String
    let attendees: Int
    let tag: String
    let imageName: String
}

class WLDDiscoveryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private var events: [WLDEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WLDAppConfig.Colors.background
        navigationItem.title = "Conventions" // Renamed from Discover
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupTableView()
        loadEvents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name: NSNotification.Name("EventCalendarUpdated"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func refreshList() {
        tableView.reloadData()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.register(WLDEventListCell.self, forCellReuseIdentifier: "WLDEventListCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 20, right: 0)
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func loadEvents() {
        events = [
            WLDEvent(name: "Anime Expo 2026", date: "July 2 - July 5", location: "Los Angeles, CA", description: "The largest anime convention in North America. Huge cosplay gatherings for Genshin, JJK, and more.", attendees: 115000, tag: "Mega Event", imageName: "new_cosplay_07"),
            WLDEvent(name: "Comiket 104", date: "August 11 - August 12", location: "Tokyo Big Sight, Japan", description: "The holy grail of doujinshi and cosplay. Expect massive lines and exclusive merch drops.", attendees: 500000, tag: "International", imageName: "new_cosplay_08"),
            WLDEvent(name: "Katsucon", date: "February 13 - February 15", location: "National Harbor, MD", description: "Famous for its beautiful gazebo and high-tier cinematic cosplay photography.", attendees: 17000, tag: "Photo Heavy", imageName: "new_cosplay_09"),
            WLDEvent(name: "Cyber City Gathering", date: "October 30 - October 31", location: "Neo Seoul Center", description: "Dedicated to Cyberpunk, Mecha, and futuristic aesthetics. Neon lights provided.", attendees: 8500, tag: "Themed", imageName: "new_cosplay_10"),
            WLDEvent(name: "Fantasy Faire", date: "May 15 - May 16", location: "Sherwood Forest Park", description: "Outdoor setting perfect for fantasy, armor, and medieval weapon props.", attendees: 5000, tag: "Outdoor", imageName: "new_cosplay_11")
        ]
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WLDEventListCell", for: indexPath) as! WLDEventListCell
        cell.configure(with: events[indexPath.row])
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let detailVC = WLDEventDetailViewController()
        detailVC.event = events[indexPath.row]
        detailVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - WLDEventListCell
class WLDEventListCell: UITableViewCell {
    
    private let containerView = UIView()
    private let eventImageView = UIImageView()
    private let nameLabel = UILabel()
    private let dateLabel = UILabel()
    private let locationLabel = UILabel()
    private let descLabel = UILabel()
    private let tagContainer = UIView()
    private let tagLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = WLDAppConfig.Colors.cardBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.shadowColor = WLDAppConfig.Colors.shadow.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowRadius = 8
        contentView.addSubview(containerView)
        
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        eventImageView.contentMode = .scaleAspectFill
        eventImageView.clipsToBounds = true
        eventImageView.layer.cornerRadius = 12
        eventImageView.backgroundColor = WLDAppConfig.Colors.sand
        containerView.addSubview(eventImageView)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = WLDAppConfig.Fonts.title(size: 18)
        nameLabel.textColor = WLDAppConfig.Colors.textPrimary
        containerView.addSubview(nameLabel)
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.font = WLDAppConfig.Fonts.title(size: 14) // Slightly bolder for dates
        dateLabel.textColor = .systemOrange // Accent color
        containerView.addSubview(dateLabel)
        
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        locationLabel.font = WLDAppConfig.Fonts.caption(size: 13)
        locationLabel.textColor = WLDAppConfig.Colors.textSecondary
        containerView.addSubview(locationLabel)
        
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        descLabel.font = WLDAppConfig.Fonts.body(size: 14)
        descLabel.textColor = WLDAppConfig.Colors.textPrimary
        descLabel.numberOfLines = 2
        containerView.addSubview(descLabel)
        
        tagContainer.translatesAutoresizingMaskIntoConstraints = false
        tagContainer.backgroundColor = WLDAppConfig.Colors.sand
        tagContainer.layer.cornerRadius = 6
        containerView.addSubview(tagContainer)
        
        tagLabel.translatesAutoresizingMaskIntoConstraints = false
        tagLabel.font = WLDAppConfig.Fonts.caption(size: 11)
        tagLabel.textColor = WLDAppConfig.Colors.textPrimary
        tagContainer.addSubview(tagLabel)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            eventImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            eventImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            eventImageView.widthAnchor.constraint(equalToConstant: 80),
            eventImageView.heightAnchor.constraint(equalToConstant: 100),
            
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            nameLabel.leadingAnchor.constraint(equalTo: eventImageView.trailingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            locationLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 2),
            locationLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            
            tagContainer.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            tagContainer.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            
            tagLabel.topAnchor.constraint(equalTo: tagContainer.topAnchor, constant: 4),
            tagLabel.bottomAnchor.constraint(equalTo: tagContainer.bottomAnchor, constant: -4),
            tagLabel.leadingAnchor.constraint(equalTo: tagContainer.leadingAnchor, constant: 8),
            tagLabel.trailingAnchor.constraint(equalTo: tagContainer.trailingAnchor, constant: -8),
            
            descLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
            descLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            descLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -12)
        ])
    }
    
    func configure(with event: WLDEvent) {
        nameLabel.text = event.name
        
        // Check if already added to calendar
        let isAdded = UserDefaults.standard.bool(forKey: "calendar_added_\(event.name)")
        dateLabel.text = isAdded ? "🗓 \(event.date)  ✅" : "🗓 \(event.date)"
        
        locationLabel.text = "📍 \(event.location)"
        descLabel.text = event.description
        tagLabel.text = event.tag
        
        WLDBitmapFetcher.shared.loadImage(from: event.imageName) { [weak self] img in
            self?.eventImageView.image = img
        }
    }
}

// MARK: - Event Detail View Controller
class WLDEventDetailViewController: UIViewController {
    
    var event: WLDEvent!
    let eventStore = EKEventStore()
    
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
        addToCalendarButton.setTitleColor(.white, for: .normal)
        addToCalendarButton.backgroundColor = .systemBlue
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
        
        // Restore button state
        let isAdded = UserDefaults.standard.bool(forKey: "calendar_added_\(post.name)")
        if isAdded {
            addToCalendarButton.setTitle("Added \u{2713}", for: .normal)
            addToCalendarButton.backgroundColor = .systemGreen
            addToCalendarButton.isEnabled = false
        }
    }
    
    @objc private func didTapCalendar() {
        let addToCalendar = { [weak self] in
            guard let self = self else { return }
            let ekEvent = EKEvent(eventStore: self.eventStore)
            ekEvent.title = self.event.name
            ekEvent.location = self.event.location
            ekEvent.notes = self.event.description
            
            // Mocking the event date 30 days into the future for presentation purposes
            ekEvent.startDate = Date().addingTimeInterval(86400 * 30)
            ekEvent.endDate = Date().addingTimeInterval(86400 * 31)
            ekEvent.calendar = self.eventStore.defaultCalendarForNewEvents
            
            do {
                try self.eventStore.save(ekEvent, span: .thisEvent)
                
                // Persist state
                UserDefaults.standard.set(true, forKey: "calendar_added_\(self.event.name)")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success", message: "\(self.event.name) has been safely added to your system calendar.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Awesome", style: .default, handler: { _ in
                        self.addToCalendarButton.setTitle("Added \u{2713}", for: .normal)
                        self.addToCalendarButton.backgroundColor = .systemGreen
                        self.addToCalendarButton.isEnabled = false
                        
                        // Notify list to refresh
                        NotificationCenter.default.post(name: NSNotification.Name("EventCalendarUpdated"), object: nil)
                    }))
                    self.present(alert, animated: true)
                }
            } catch {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Error", message: "Failed to save the event to calendar.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self.present(alert, animated: true)
                }
            }
        }
        
        // Request Permission
        if #available(iOS 17.0, *) {
            eventStore.requestWriteOnlyAccessToEvents { granted, error in
                if granted { addToCalendar() }
            }
        } else {
            eventStore.requestAccess(to: .event) { granted, error in
                if granted { addToCalendar() }
            }
        }
    }
}
