import UIKit
import AVFoundation

class WLDCameraViewController: UIViewController {
    
    // UI Elements
    private let previewLayer = UIView()
    private let shutterButton = UIButton(type: .system)
    private let closeButton = UIButton(type: .system)
    
    // Simulated viewfinder
    private let viewfinderView = UIImageView()
    
    // Actions
    var onPostToStory: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        // 1. Simulated viewfinder (camera preview)
        // In a real app this is AVCaptureVideoPreviewLayer.
        viewfinderView.contentMode = .scaleAspectFill
        viewfinderView.clipsToBounds = true
        // Load a random image        // Use local placeholder for viewfinder
        WLDBitmapFetcher.shared.loadImage(from: "resource_img_01.jpg") { [weak self] img in
            self?.viewfinderView.image = img
        }
        view.addSubview(viewfinderView)
        viewfinderView.pin(to: view)
        
        // Overlay to look like camera UI
        let overlay = UIView()
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        view.addSubview(overlay)
        overlay.pin(to: view)
        
        // 2. Shutter Button
        shutterButton.backgroundColor = .white
        shutterButton.layer.cornerRadius = 35
        shutterButton.layer.borderWidth = 4
        shutterButton.layer.borderColor = UIColor.lightGray.cgColor
        shutterButton.addTarget(self, action: #selector(didTapShutter), for: .touchUpInside)
        
        view.addSubview(shutterButton)
        shutterButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shutterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shutterButton.widthAnchor.constraint(equalToConstant: 70),
            shutterButton.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        // 3. Close Button
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        closeButton.layer.cornerRadius = 20
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func didTapShutter() {
        // Simulate "Capture" animation
        let flashView = UIView(frame: view.bounds)
        flashView.backgroundColor = .white
        flashView.alpha = 0
        view.addSubview(flashView)
        
        UIView.animate(withDuration: 0.1, animations: {
            flashView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                flashView.alpha = 0
            } completion: { _ in
                flashView.removeFromSuperview()
                self.showPreview()
            }
        }
    }
    
    private func showPreview() {
        guard let image = viewfinderView.image else { return }
        
        let previewVC = WLDPhotoPreviewViewController()
        previewVC.image = image
        previewVC.onPost = { [weak self] in
            // Handle posting logic
            self?.dismiss(animated: true) {
                // Could call delegate here
                print("Posted to Story!")
            }
        }
        previewVC.modalPresentationStyle = .fullScreen
        present(previewVC, animated: false)
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
}

// Helper: Preview View Controller
class WLDPhotoPreviewViewController: UIViewController {
    
    var image: UIImage?
    var onPost: (() -> Void)?
    
    private let imageView = UIImageView()
    private let sendButton = UIButton(type: .system)
    private let retryButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupUI()
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = image
        view.addSubview(imageView)
        imageView.pin(to: view)
        
        // Send Button "Your Story"
        sendButton.setTitle(" Your Story ", for: .normal)
        sendButton.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        sendButton.tintColor = .black
        sendButton.backgroundColor = .white
        sendButton.layer.cornerRadius = 20
        sendButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        
        view.addSubview(sendButton)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            sendButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            sendButton.heightAnchor.constraint(equalToConstant: 44),
            sendButton.widthAnchor.constraint(equalToConstant: 140)
        ])
        
        // Retry Button
        retryButton.setImage(UIImage(systemName: "trash.fill"), for: .normal)
        retryButton.tintColor = .white
        retryButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        retryButton.layer.cornerRadius = 20
        retryButton.addTarget(self, action: #selector(didTapRetry), for: .touchUpInside)
        
        view.addSubview(retryButton)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            retryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            retryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            retryButton.widthAnchor.constraint(equalToConstant: 40),
            retryButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func didTapSend() {
        // AUTH CHECK
        WLDAuthService.shared.ensureLoggedIn(on: self) { [weak self] in
            self?.performPost()
        }
    }
        
    private func performPost() {
        // Show success / loading
        let hud = UIView()
        hud.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        hud.layer.cornerRadius = 10
        let label = UILabel()
        label.text = "Posted!"
        label.textColor = .white
        
        view.addSubview(hud)
        hud.translatesAutoresizingMaskIntoConstraints = false
        hud.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: hud.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: hud.centerYAnchor).isActive = true
        
        hud.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        hud.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        hud.widthAnchor.constraint(equalToConstant: 100).isActive = true
        hud.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        // Add to Manager
        if let img = self.image {
            WLDFeedController.shared.addPost(image: img, caption: "My Story Update!")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            self.onPost?()
        }
    }
    
    @objc private func didTapRetry() {
        dismiss(animated: false)
    }
}
