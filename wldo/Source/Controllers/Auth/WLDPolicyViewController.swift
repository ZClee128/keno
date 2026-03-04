import UIKit

enum WLDPolicyType {
    case terms
    case privacy
    case community

    var title: String {
        switch self {
        case .terms: return "Terms of Service"
        case .privacy: return "Privacy Policy"
        case .community: return "Community Guidelines"
        }
    }

    var content: String {
        switch self {
        case .terms:
            return """
WLDO - Terms of Service and Privacy Policy

Last Updated: January 2026

Welcome to Keno Vision! Share your Cosplay visual arts thoughtfully and enjoy the creative community.

1. Terms of Service

2. Service Description
Keno is a premier Cosplay sharing platform where artists can post photos/videos of their craft, share costume-making tips, and connect with other enthusiasts.

2. User Conduct
- Content should revolve around Cosplay, props making, ACG culture and be respectful.
- No hate speech, harassment, or inappropriate content.
- Respect copyright, especially regarding photos and videos.
- Be authentic and supportive in your interactions.

3. User Generated Content
- You own your content, but you grant Keno license to display them.
- We may remove content that violates our community guidelines.

4. Account Security
- Keep your login secure. You are responsible for your account activity.
- Report any suspicious activity immediately.

2. Privacy Policy

1. Information Collection
We collect:
- Profile info (username, bio)
- Usage data (posts, likes, follows)
- Device info for app optimization

2. Information Usage
- To connect you with other creators
- To show relevant Cosplay and ACG content
- To ensure platform safety

3. Sharing
- We do not sell your data.
- Public posts are visible to all users.

4. Contact
Email: support@wldo.app

Thank you for joining Keno!
"""
        case .privacy:
            return """
We care about your privacy.

1) Information We Collect
- Account info: email and login credentials.
- Content info: posts, messages, and interactions.
- Device info: diagnostics for security.

2) How We Use Information
- To provide and improve the service.
- To keep the community safe.
- To comply with legal obligations.

3) What We Don’t Do
- We do not sell your sensitive personal information.

4) Your Choices
- You may update your profile information.
- You may request account deletion.
- You may report content that violates our rules.

By continuing, you confirm you have read and agree to this Privacy Policy.
"""
        case .community:
            return """
Keep Keno safe and welcoming:

1) Be Respectful
- No hate, harassment, or bullying.

2) Keep It Safe and Genuine
- No scams, spam, or deceptive content.

3) Respect Copyright and Privacy
- Only post content you own.

4) Disallowed Content
- No violence, sexual content, or dangerous behavior.
- Zero tolerance for exploiting or endangering minors.

Let's build a positive ACG and Cosplay community together.
"""
        }
    }
}

class WLDPolicyViewController: UIViewController {
    private let type: WLDPolicyType
    private let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isSelectable = true
        tv.alwaysBounceVertical = true
        tv.backgroundColor = .clear
        tv.textColor = WLDAppConfig.Colors.textPrimary
        tv.font = .systemFont(ofSize: 15)
        tv.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        return tv
    }()

    init(type: WLDPolicyType) {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WLDAppConfig.Colors.background
        title = type.title

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Close", style: .done, target: self, action: #selector(close))
        navigationController?.navigationBar.tintColor = WLDAppConfig.Colors.lifestyleAccent

        textView.text = type.content
        view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func close() {
        dismiss(animated: true)
    }
}

class WLDLaunchAgreementViewController: UIViewController {

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let messageTextView = UITextView()
    private let agreeButton = UIButton(type: .system)
    private let disagreeButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WLDAppConfig.Colors.background
        
        setupUI()
    }
    
    private func setupUI() {
        // Background Image
        let bgImageView = UIImageView(frame: view.bounds)
        bgImageView.image = UIImage(named: "new_cosplay_01")
        bgImageView.contentMode = .scaleAspectFill
        bgImageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(bgImageView)
        
        // Blur Effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = view.bounds
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurView.alpha = 0.85
        view.addSubview(blurView)
        
        // App Logo/Title
        let logoLabel = UILabel()
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        logoLabel.text = "KENO"
        logoLabel.font = UIFont.systemFont(ofSize: 42, weight: .black)
        logoLabel.textColor = .white
        logoLabel.textAlignment = .center
        view.addSubview(logoLabel)
        
        // Container
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor(white: 0, alpha: 0.6) // Semi-transparent black
        containerView.layer.cornerRadius = 24
        containerView.layer.borderWidth = 1
        containerView.layer.borderColor = UIColor(white: 1, alpha: 0.2).cgColor
        
        // Inner Blur for container
        let innerBlurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let innerBlurView = UIVisualEffectView(effect: innerBlurEffect)
        innerBlurView.frame = containerView.bounds
        innerBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        innerBlurView.layer.cornerRadius = 24
        innerBlurView.clipsToBounds = true
        containerView.insertSubview(innerBlurView, at: 0)
        
        view.addSubview(containerView)
        
        // Title
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Community Agreement"
        titleLabel.font = WLDAppConfig.Fonts.header(size: 22)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        // Message
        messageTextView.translatesAutoresizingMaskIntoConstraints = false
        messageTextView.isEditable = false
        messageTextView.isScrollEnabled = true
        messageTextView.backgroundColor = .clear
        messageTextView.textColor = UIColor(white: 0.9, alpha: 1.0)
        messageTextView.font = WLDAppConfig.Fonts.body(size: 15)
        messageTextView.textAlignment = .left
        
        let termsText = "Welcome to Keno Vision.\n\nTo ensure a safe and inspiring environment, please agree to our Terms of Service and Privacy Policy.\n\nGuidelines:\nWe have zero tolerance for objectionable content or abusive users. Any inappropriate content will be removed, and violators will be banned. Users can block other members or report abusive content at any time directly within the app.\n\nEnjoy the aesthetics. 📸"
        messageTextView.text = termsText
        containerView.addSubview(messageTextView)
        
        // Agree Button
        agreeButton.translatesAutoresizingMaskIntoConstraints = false
        agreeButton.setTitle("Agree & Enter", for: .normal)
        agreeButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        agreeButton.backgroundColor = .white
        agreeButton.setTitleColor(.black, for: .normal)
        agreeButton.layer.cornerRadius = 28
        agreeButton.layer.shadowColor = UIColor.white.cgColor
        agreeButton.layer.shadowOpacity = 0.3
        agreeButton.layer.shadowOffset = CGSize(width: 0, height: 4)
        agreeButton.layer.shadowRadius = 8
        agreeButton.addTarget(self, action: #selector(didTapAgree), for: .touchUpInside)
        view.addSubview(agreeButton) // Put button outside container at bottom
        
        // Disagree Button
        disagreeButton.translatesAutoresizingMaskIntoConstraints = false
        disagreeButton.setTitle("Decline", for: .normal)
        disagreeButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        disagreeButton.setTitleColor(UIColor(white: 1, alpha: 0.6), for: .normal)
        disagreeButton.addTarget(self, action: #selector(didTapDisagree), for: .touchUpInside)
        view.addSubview(disagreeButton)
        
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            containerView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 40),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: agreeButton.topAnchor, constant: -40),
            
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            messageTextView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            messageTextView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            messageTextView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            messageTextView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -32),
            
            disagreeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            disagreeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            disagreeButton.heightAnchor.constraint(equalToConstant: 44),
            
            agreeButton.bottomAnchor.constraint(equalTo: disagreeButton.topAnchor, constant: -10),
            agreeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            agreeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            agreeButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    @objc private func didTapAgree() {
        UserDefaults.standard.set(true, forKey: "has_agreed_to_privacy")
        
        if let sceneDelegate = view.window?.windowScene?.delegate as? UIWindowSceneDelegate,
           let window = (sceneDelegate as? AppDelegate)?.window ?? UIApplication.shared.delegate?.window {
            
            let tabBar = WLDMainTab()
            window?.rootViewController = tabBar
            UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        } else {
            // Fallback
            (UIApplication.shared.delegate as? AppDelegate)?.ox_0BsIkPfu()
        }
    }
    
    @objc private func didTapDisagree() {
        let alert = UIAlertController(title: "Agreement Required", message: "You must agree to the User Agreement and Privacy Policy to use Keno.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Got it", style: .default))
        present(alert, animated: true)
    }
}
