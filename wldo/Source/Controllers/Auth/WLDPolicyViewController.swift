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

Welcome to WLDO! Explore the world of reptiles responsibly and enjoy the community.

1. Terms of Service

1. Service Description
WLDO is a reptile sharing social platform where users can post photos/videos of their pets, share care tips, and connect with other enthusiasts.

2. User Conduct
- Content must be reptile-related and respectful.
- No hate speech, harassment, or inappropriate content.
- Respect copyright, especially regarding photos and videos.
- Be authentic and supportive in your interactions.

3. User Generated Content
- You own your content, but you grant WLDO license to display them.
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
- To connect you with other users
- To show relevant reptile content
- To ensure platform safety

3. Sharing
- We do not sell your data.
- Public posts are visible to all users.

4. Contact
Email: support@wldo.app

Thank you for joining WLDO!
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
Keep WLDO safe and welcoming:

1) Be Respectful
- No hate, harassment, or bullying.

2) Keep It Safe and Genuine
- No scams, spam, or deceptive content.

3) Respect Copyright and Privacy
- Only post content you own.

4) Disallowed Content
- No violence, sexual content, or dangerous behavior.
- Zero tolerance for exploiting or endangering minors.

Let’s build a positive reptile community together.
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
        navigationController?.navigationBar.tintColor = WLDAppConfig.Colors.reptileGreen

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
