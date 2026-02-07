import UIKit

class KENLoginViewController: UIViewController, UITextFieldDelegate, UIGestureRecognizerDelegate, UITextViewDelegate {
    
    // Callback
    var onLoginSuccess: (() -> Void)?
    
    // UI Elements
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let backgroundImageView = UIImageView()
    private let logoLabel = UILabel()
    private let containerView = UIView()
    private let emailField = UITextField()
    private let passwordField = UITextField()
    private let loginButton = UIButton(type: .system)
    private let hintLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    
    private let agreementButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "square"), for: .normal)
        btn.tintColor = KENConstants.Colors.reptileGreen
        return btn
    }()
    
    private let agreementTextView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isScrollEnabled = false
        tv.backgroundColor = .clear
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        return tv
    }()
    
    private var hasAgreed: Bool = false {
        didSet { updateAgreementUI() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = KENConstants.Colors.background
        setupUI()
        setupActions()
        setupKeyboardObservers()
        
        // Ensure scroll starts at top
        scrollView.contentOffset = .zero
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Ensure background is correct
        backgroundImageView.frame = view.bounds
    }
    
    private func setupUI() {
        // Background
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.image = UIImage(named: "login_bg") 
        view.addSubview(backgroundImageView)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor.black.withAlphaComponent(0.3).cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = view.bounds
        backgroundImageView.layer.addSublayer(gradientLayer)

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor)
        ])
        
        // Close Button
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
        
        // Logo
        logoLabel.text = "KENO"
        logoLabel.font = UIFont.systemFont(ofSize: 48, weight: .heavy)
        logoLabel.textColor = KENConstants.Colors.reptileGreen
        logoLabel.textAlignment = .center
        
        contentView.addSubview(logoLabel)
        logoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            logoLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 80),
            logoLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Container
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 24
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        containerView.layer.shadowOpacity = 0.1
        containerView.layer.shadowRadius = 12
        
        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 60),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
        
        // Fields
        configureField(emailField, placeholder: "Email", icon: "envelope")
        configureField(passwordField, placeholder: "Password", icon: "lock")
        passwordField.isSecureTextEntry = true
        emailField.keyboardType = .emailAddress
        emailField.autocapitalizationType = .none
        
        let stack = UIStackView(arrangedSubviews: [emailField, passwordField])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        
        containerView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 30),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stack.heightAnchor.constraint(equalToConstant: 110)
        ])
        
        // Agreement Checkbox
        containerView.addSubview(agreementButton)
        containerView.addSubview(agreementTextView)
        
        agreementButton.translatesAutoresizingMaskIntoConstraints = false
        agreementTextView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            agreementButton.topAnchor.constraint(equalTo: stack.bottomAnchor, constant: 20),
            agreementButton.leadingAnchor.constraint(equalTo: stack.leadingAnchor),
            agreementButton.widthAnchor.constraint(equalToConstant: 24),
            agreementButton.heightAnchor.constraint(equalToConstant: 24),
            
            agreementTextView.centerYAnchor.constraint(equalTo: agreementButton.centerYAnchor),
            agreementTextView.leadingAnchor.constraint(equalTo: agreementButton.trailingAnchor, constant: 8),
            agreementTextView.trailingAnchor.constraint(equalTo: stack.trailingAnchor)
        ])
        
        configureAgreementText()
        
        // Button
        loginButton.setTitle("LOGIN / REGISTER", for: .normal)
        loginButton.backgroundColor = KENConstants.Colors.reptileGreen
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        loginButton.layer.cornerRadius = 12
        
        containerView.addSubview(loginButton)
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalTo: agreementButton.bottomAnchor, constant: 24),
            loginButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -30)
        ])
        
        updateAgreementUI()
    }
    
    private func configureField(_ field: UITextField, placeholder: String, icon: String) {
        field.backgroundColor = UIColor(white: 0.95, alpha: 1.0)
        field.layer.cornerRadius = 12
        field.textColor = .black
        field.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.gray])
        
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = .gray
        iconView.contentMode = .center
        iconView.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        field.leftView = iconView
        field.leftViewMode = .always
    }
    
    private func configureAgreementText() {
        let text = "I agree to the Terms of Service and Privacy Policy"
        let attributed = NSMutableAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 12),
            .foregroundColor: UIColor.darkGray
        ])

        let linkRange = (text as NSString).range(of: "Terms of Service and Privacy Policy")
        attributed.addAttribute(.link, value: "keno://terms", range: linkRange)
        attributed.addAttribute(.foregroundColor, value: KENConstants.Colors.reptileGreen, range: linkRange)
        attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: linkRange)

        agreementTextView.attributedText = attributed
        agreementTextView.delegate = self
    }

    private func updateAgreementUI() {
        let imageName = hasAgreed ? "checkmark.square.fill" : "square"
        agreementButton.setImage(UIImage(systemName: imageName), for: .normal)
        loginButton.isEnabled = hasAgreed
        loginButton.alpha = hasAgreed ? 1.0 : 0.5
    }

    @objc private func toggleAgreement() {
        hasAgreed.toggle()
    }
    
    private func setupActions() {
        loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
        agreementButton.addTarget(self, action: #selector(toggleAgreement), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Set text field delegates for auto-scroll
        emailField.delegate = self
        passwordField.delegate = self
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        let height = keyboardFrame.height
        scrollView.contentInset.bottom = height
        scrollView.verticalScrollIndicatorInsets.bottom = height
        
        // Auto-scroll to active text field
        if let activeField = [emailField, passwordField].first(where: { $0.isFirstResponder }) {
            let fieldFrame = activeField.convert(activeField.bounds, to: scrollView)
            scrollView.scrollRectToVisible(fieldFrame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
    
    @objc private func didTapLogin() {
        guard hasAgreed else {
            showAlert(message: "Please agree to the Terms and Privacy Policy.")
            return
        }
        
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else {
            showAlert(message: "Please enter email and password.")
            return
        }
        
        // Unified Logic
        if KENAuthManager.shared.isEmailRegistered(email) {
            // Treat as Login
            if password == "123456" {
                guard let userId = KENAuthManager.shared.getUserId(for: email) else {
                    // This should never happen if isEmailRegistered is true
                    showAlert(message: "Account error. Please try again or re-register.")
                    return
                }
                KENAuthManager.shared.login(id: userId, username: suggestUsername(from: email), email: email)
                onLoginSuccess?()
            } else {
                showAlert(message: "Incorrect password for this email.")
            }
        } else {
            // Treat as Register - always create new account with fresh UUID
            KENAuthManager.shared.register(email: email, username: suggestUsername(from: email))
            onLoginSuccess?()
        }
    }
    
    private func suggestUsername(from email: String) -> String {
        // Special case for seed account
        if email.lowercased() == "seed@keno.com" {
            return "ReptileFan"
        }
        return email.split(separator: "@").first.map(String.init) ?? "User"
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - UITextViewDelegate
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        if URL.absoluteString == "keno://terms" {
            let vc = KENPolicyViewController(type: .terms)
            let nav = UINavigationController(rootViewController: vc)
            present(nav, animated: true)
            return false
        }
        return true
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let view = touch.view as? UIButton { return false }
        if let view = touch.view as? UITextView { return false }
        return true
    }
}

