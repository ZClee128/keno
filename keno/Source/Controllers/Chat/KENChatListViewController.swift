import UIKit

class KENChatListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let tableView = UITableView()
    

    
    private var chatList: [(id: String, name: String)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Messages"
        view.backgroundColor = KENConstants.Colors.background
        setupTableView()
        setupNavBar()
        loadChats()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateMessages), name: NSNotification.Name("KENNewMessage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadChats), name: NSNotification.Name("KENUserBlocked"), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func didUpdateMessages() {
        loadChats()
    }
    
    @objc private func loadChats() {
        // Only show conversations with actual messages
        let conversationIds = KENMessageManager.shared.getConversationUserIds()
        let blocked = KENAuthManager.shared.blockedUsers
        let myUserId = KENAuthManager.shared.currentUser?.id ?? ""
        
        chatList = conversationIds
            .filter { !blocked.contains(extractUsername(from: $0)) }
            .filter { $0 != myUserId }  // Don't show conversation with yourself
            .map { (id: $0, name: extractUsername(from: $0)) }
        
        tableView.reloadData()
    }
    
    private func extractUsername(from userId: String) -> String {
        // Extract username from userId (e.g., "user_GeckoMaster" -> "GeckoMaster")
        if userId.hasPrefix("user_") {
            return String(userId.dropFirst(5))
        }
        return userId
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadChats()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.pin(to: view)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(KENChatListCell.self, forCellReuseIdentifier: "KENChatListCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        tableView.rowHeight = 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KENChatListCell", for: indexPath) as? KENChatListCell else {
            return UITableViewCell()
        }
        
        let user = chatList[indexPath.row]
        let messages = KENMessageManager.shared.getMessages(for: user.id)
        
        if let last = messages.last {
            cell.configure(name: user.name, message: last.text, time: "Just now")
        } else {
            cell.configure(name: user.name, message: "Start a conversation!", time: "")
        }
        
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let chatVC = KENChatDetailViewController()
        let user = chatList[indexPath.row]
        chatVC.chatTitle = user.name
        chatVC.targetUserId = user.id
        chatVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
