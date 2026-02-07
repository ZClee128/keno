import UIKit
import AVFoundation

class KENVideoPlayerView: UIView {
    
    private var playerLayer: AVPlayerLayer?
    private var player: AVPlayer?
    private let coverImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(coverImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
        coverImageView.frame = bounds
    }
    
    func configure(with videoName: String, coverURL: String? = nil) {
        // Stop previous
        cleanup()
        
        // Show cover if available
        if let cover = coverURL {
            coverImageView.isHidden = false
            KENImageLoader.shared.loadImage(from: cover) { [weak self] img in
                self?.coverImageView.image = img
            }
        } else {
            coverImageView.isHidden = true
        }
        guard let path = Bundle.main.path(forResource: videoName, ofType: nil) else {
            print("Video file not found: \(videoName)")
            return
        }
        
        let url = URL(fileURLWithPath: path)
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        player?.actionAtItemEnd = .none
        
        // Loop logic
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd), name: .AVPlayerItemDidPlayToEndTime, object: playerItem)
        
        // Background/Foreground logic
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.videoGravity = .resizeAspectFill
        playerLayer?.frame = bounds
        layer.addSublayer(playerLayer!)
        
        // Bring cover to front until video is ready
        bringSubviewToFront(coverImageView)
        
        // Play
        play()
        
        // Observer for when video starts playing to hide cover
        player?.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "timeControlStatus" {
            if player?.timeControlStatus == .playing {
                UIView.animate(withDuration: 0.3) {
                    self.coverImageView.alpha = 0
                } completion: { _ in
                    self.coverImageView.isHidden = true
                    self.coverImageView.alpha = 1
                }
            }
        }
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    @objc private func playerItemDidReachEnd(notification: NSNotification) {
        if let playerItem = notification.object as? AVPlayerItem {
            playerItem.seek(to: .zero) { [weak self] _ in
                self?.player?.play()
            }
        }
    }
    
    @objc private func appDidEnterBackground() {
        // Disconnect player from layer to allow background playback
        playerLayer?.player = nil
    }
    
    @objc private func appWillEnterForeground() {
        // Reconnect player to layer
        playerLayer?.player = player
    }
    
    func cleanup() {
        player?.pause()
        player?.removeObserver(self, forKeyPath: "timeControlStatus")
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
