import UIKit

class WLDCreatePostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var selectedImage: UIImage?

    private let textView: UITextView = {
        let tv = UITextView()
        tv.font = WLDAppConfig.Fonts.body(size: 16)
        tv.text = "Describe your look or photography..."
        tv.textColor = .lightGray
        tv.backgroundColor = .clear
        tv.textContainerInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        return tv
    }()
    
    private let imageContainer: UIView = {
        let v = UIView()
        v.backgroundColor = WLDAppConfig.Colors.sand
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let addIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "plus.viewfinder"))
        iv.tintColor = WLDAppConfig.Colors.textSecondary
        iv.contentMode = .scaleAspectFit
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = WLDAppConfig.Colors.cardBackground
        title = "New Post"
        
        let postBtn = UIBarButtonItem(title: "Share", style: .done, target: self, action: #selector(didTapPost))
        postBtn.tintColor = .systemBlue
        navigationItem.rightBarButtonItem = postBtn
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        
        textView.delegate = self
        setupUI()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapImage))
        imageContainer.addGestureRecognizer(tap)
        imageContainer.isUserInteractionEnabled = true
    }
    
    private func setupUI() {
        view.addSubview(textView)
        view.addSubview(imageContainer)
        imageContainer.addSubview(imageView)
        imageContainer.addSubview(addIcon)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        imageContainer.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        addIcon.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 120),
            
            imageContainer.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 10),
            imageContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            imageContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            imageContainer.heightAnchor.constraint(equalTo: imageContainer.widthAnchor, multiplier: 1.25), // 4:5 ratio preferred
            
            imageView.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor),
            
            addIcon.centerXAnchor.constraint(equalTo: imageContainer.centerXAnchor),
            addIcon.centerYAnchor.constraint(equalTo: imageContainer.centerYAnchor),
            addIcon.widthAnchor.constraint(equalToConstant: 40),
            addIcon.heightAnchor.constraint(equalToConstant: 40)
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
            addIcon.isHidden = true
        }
        picker.dismiss(animated: true)
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = WLDAppConfig.Colors.textPrimary
        }
    }

    @objc private func didTapPost() {
        guard let image = selectedImage else {
            let alert = UIAlertController(title: "Photo Required", message: "Please select a photo for your post.", preferredStyle: .alert)
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
