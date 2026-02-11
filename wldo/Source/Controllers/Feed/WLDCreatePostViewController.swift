import UIKit

class WLDCreatePostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var selectedImage: UIImage?

    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = WLDAppConfig.Fonts.regular(size: 16)
        tv.text = "Share something about your reptile..."
        tv.textColor = .lightGray
        tv.backgroundColor = .systemGray6
        tv.layer.cornerRadius = 8
        tv.textContainerInset = UIEdgeInsets(top: 12, left: 8, bottom: 12, right: 8)
        return tv
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .systemGray5
        iv.image = UIImage(systemName: "photo.badge.plus")
        iv.tintColor = WLDAppConfig.Colors.reptileGreen
        iv.contentMode = .center
        iv.isUserInteractionEnabled = true
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "New Post"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .done, target: self, action: #selector(didTapPost))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        
        textView.delegate = self
        setupUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageView.addGestureRecognizer(tap)
    }
    
    private func setupUI() {
        view.addSubview(textView)
        view.addSubview(imageView)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textView.heightAnchor.constraint(equalToConstant: 120),
            
            imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.6)
        ])
    }
    
    @objc private func didTapImage() {
        let pc = UIImagePickerController()
        pc.sourceType = .photoLibrary
        pc.delegate = self
        present(pc, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            self.selectedImage = image
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
        }
        picker.dismiss(animated: true)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .label
        }
    }

    @objc private func didTapPost() {
        guard let image = selectedImage else {
            let alert = UIAlertController(title: "Missing Photo", message: "Please select a photo for your post.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        let caption = textView.textColor == .lightGray ? "" : (textView.text ?? "")
        WLDFeedController.shared.addPost(image: image, caption: caption)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
}
