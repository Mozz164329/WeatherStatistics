
import UIKit

@objc extension UIImageView {

    static var imageCache = NSCache<NSString, UIImage>()

    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }

        if let cachedImage = Self.imageCache.object(forKey: imageURL.absoluteString as NSString) {
            self.image = cachedImage
        }
        else {

            DispatchQueue.global().async {
                guard let imageData = try? Data(contentsOf: imageURL) else { return }

                let image = UIImage(data: imageData)
                Self.imageCache.setObject(image ?? UIImage(), forKey: imageURL.absoluteString as NSString)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
