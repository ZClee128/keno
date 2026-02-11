import UIKit

class WLDSettingsViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return 1 }
        return 2 // Log Out and Delete Account
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "App Features" : "Account & Privacy"
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return "Background Audio allows you to continue listening to nature videos and ambient sounds while the app is in the background or the screen is locked."
        }
        return "Deleting your account is permanent and will remove all your data."
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.textColor = .label
        cell.accessoryType = .none
        cell.selectionStyle = .default
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "🔊 Background Playback"
            let statusLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 60, height: 20))
            statusLabel.text = "Active"
            statusLabel.textAlignment = .right
            statusLabel.textColor = .secondaryLabel
            statusLabel.font = .systemFont(ofSize: 14)
            cell.accessoryView = statusLabel
            cell.selectionStyle = .none
        } else {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Log Out"
                cell.textLabel?.textColor = .label
            } else {
                cell.textLabel?.text = "Delete Account"
                cell.textLabel?.textColor = .red
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                logout()
            } else {
                confirmAccountDeletion()
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func logout() {
        WLDAuthService.shared.logout()
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.switchToMainApp()
        }
    }
    
    private func confirmAccountDeletion() {
        let alert = UIAlertController(
            title: "Delete Account?",
            message: "This action is permanent and cannot be undone. All your data will be cleared.",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "Delete Forever", style: .destructive, handler: { _ in
            WLDAuthService.shared.deleteAccount()
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.switchToMainApp()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
}
