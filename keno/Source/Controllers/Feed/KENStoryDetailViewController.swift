import UIKit

class KENStoryDetailViewController: UIViewController {

    var storyName: String?
    
    // UI Elements
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .black
        return iv
    }()
    
    private let progressView: UIProgressView = {
        let pv = UIProgressView(progressViewStyle: .bar)
        pv.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        pv.progressTintColor = .white
        pv.progress = 0
        return pv
    }()
    
    private let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        btn.setImage(UIImage(systemName: "xmark", withConfiguration: config), for: .normal)
        btn.tintColor = .white
        return btn
    }()
    
    private let userLabel: UILabel = {
        let label = UILabel()
        label.font = KENConstants.Fonts.title(size: 16)
        label.textColor = .white
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOpacity = 0.5
        label.layer.shadowRadius = 2
        label.layer.shadowOffset = CGSize(width: 0, height: 1)
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
        loadStory()
        startProgress()
        
        // Tap to close
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapClose))
        view.addGestureRecognizer(tap)
    }
    
    private func setupUI() {
        view.addSubview(imageView)
        view.addSubview(progressView)
        view.addSubview(closeButton)
        view.addSubview(userLabel)
        
        imageView.pin(to: view)
        
        progressView.translatesAutoresizingMaskIntoConstraints = false
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            progressView.heightAnchor.constraint(equalToConstant: 4),
            
            userLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 16),
            userLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            closeButton.centerYAnchor.constraint(equalTo: userLabel.centerYAnchor),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
    }
    
    private func loadStory() {
        guard let name = storyName else { return }
        userLabel.text = name
        
        // Use local placeholder instead of external URL
        let localStories = ["1.jpg", "2.jpg", "placeholder_reptile_1"]
        let urlString = localStories.randomElement()!
        KENImageLoader.shared.loadImage(from: urlString) { [weak self] image in
            self?.imageView.image = image
        }
    }
    
    private func startProgress() {
        UIView.animate(withDuration: 3.0, delay: 0, options: .curveLinear) {
            self.progressView.setProgress(1.0, animated: true)
            self.progressView.layoutIfNeeded()
        } completion: { _ in
            // Keep open for user to view
             // self.didTapClose()
        }
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
}
