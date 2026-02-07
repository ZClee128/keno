import UIKit

class KENChatDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    var chatTitle: String?
    var targetUserId: String?
    
    private var messages: [KENMessage] = []
    
    // ... (Views same)
    private let tableView = UITableView()
    
    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: -2)
        return view
    }()
    
    private let messageField: UITextField = {
        let field = UITextField()
        field.placeholder = "Type a message..."
        field.borderStyle = .none
        field.font = KENConstants.Fonts.body(size: 16)
        return field
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = KENConstants.Colors.reptileGreen
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = chatTitle ?? "Chat"
        view.backgroundColor = KENConstants.Colors.background
        setupUI()
        setupNavBar()
        loadMessages()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveMessage(_:)), name: NSNotification.Name("KENNewMessage"), object: nil)
    }
    
    private func setupNavBar() {
        let moreBtn = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: #selector(didTapMore))
        navigationItem.rightBarButtonItem = moreBtn
        navigationController?.navigationBar.tintColor = KENConstants.Colors.reptileGreen
    }
    
    @objc private func didTapMore() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Report User", style: .destructive, handler: { _ in
            self.showReportConfirmation()
        }))
        
        alert.addAction(UIAlertAction(title: "Block User", style: .destructive, handler: { _ in
            self.confirmBlockUser()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showReportConfirmation() {
        let alert = UIAlertController(title: "User Reported", message: "Thank you for the report. We will investigate this user's activity.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func confirmBlockUser() {
        guard let username = chatTitle else { return }
        let alert = UIAlertController(title: "Block \(username)?", message: "You will no longer see messages from this user.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Block", style: .destructive, handler: { _ in
            KENAuthManager.shared.blockUser(username: username)
            self.navigationController?.popViewController(animated: true)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func loadMessages() {
        if let targetId = targetUserId {
            messages = KENMessageManager.shared.getMessages(for: targetId)
            tableView.reloadData()
            scrollToBottom()
        }
    }
    
    @objc private func didReceiveMessage(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let chatId = userInfo["chatId"] as? String,
              chatId == self.targetUserId else { return }
        
        loadMessages()
    }
    
    private func setupUI() {
        // ... (Layout code same)
        view.addSubview(tableView)
        view.addSubview(inputContainerView)
        inputContainerView.addSubview(messageField)
        inputContainerView.addSubview(sendButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        inputContainerView.translatesAutoresizingMaskIntoConstraints = false
        messageField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomAnchor: NSLayoutYAxisAnchor
        if #available(iOS 15.0, *) {
            bottomAnchor = view.keyboardLayoutGuide.topAnchor
        } else {
            bottomAnchor = view.safeAreaLayoutGuide.bottomAnchor
        }
        
        NSLayoutConstraint.activate([
            inputContainerView.bottomAnchor.constraint(equalTo: bottomAnchor), // Fixed for iOS compatibility
            inputContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputContainerView.heightAnchor.constraint(equalToConstant: 50),
            
            messageField.leadingAnchor.constraint(equalTo: inputContainerView.leadingAnchor, constant: 16),
            messageField.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            messageField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            sendButton.trailingAnchor.constraint(equalTo: inputContainerView.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: inputContainerView.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.heightAnchor.constraint(equalToConstant: 30),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor)
        ])
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(KENMessageCell.self, forCellReuseIdentifier: "KENMessageCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.allowsSelection = false
        
        sendButton.addTarget(self, action: #selector(didTapSend), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        tap.delegate = self // Set delegate
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func didTapSend() {
        guard let text = messageField.text, !text.isEmpty, let targetId = targetUserId else { return }
        
        // AUTH CHECK
        KENAuthManager.shared.ensureLoggedIn(on: self) {
            KENMessageManager.shared.sendMessage(text: text, to: targetId)
            self.messageField.text = ""
        }
    }
    
    private func scrollToBottom() {
        if !messages.isEmpty {
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    // MARK: - TableView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KENMessageCell", for: indexPath) as? KENMessageCell else {
            return UITableViewCell()
        }
        let message = messages[indexPath.row]
        cell.configure(text: message.text, isOutgoing: message.isMe)
        return cell
    }
    
    // MARK: - UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        // If the touch is inside the input container, don't trigger the dismissal tap
        // This ensures the button receives the touch correctly without the frame moving first
        let location = touch.location(in: view)
        if inputContainerView.frame.contains(location) {
            return false
        }
        return true
    }
}
