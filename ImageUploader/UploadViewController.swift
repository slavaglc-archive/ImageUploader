import UIKit
import ImgurAnonymousAPI

class UploadViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var urlTextField: UITextField!
    
    private let currentUser = Account.shared
    
    private var selectedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toAuthInImgur()
    }
    

    @IBAction func buttonTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            presentImagePicker()
        } else {
            uploadImageToImgur(image: selectedImage)
        }
    }
    
    private func toAuthInImgur(){
        
        if let reqUrl = URL(string: "https://api.imgur.com/oauth2/token?refresh_token=\(currentUser.refreshToken ?? "")&client_id=\(currentUser.clientID ?? "")&client_secret=\(currentUser.imgurSecret ?? "")&grant_type=refresh_token")
            {
            
            
                let request = NSMutableURLRequest(url: reqUrl)
            let bodyString = "grant_type=refresh_token&client_secret=\(currentUser.imgurSecret ?? "")&client_id=\(String(describing: currentUser.clientID))&refresh_token=\(currentUser.refreshToken ?? "")"

                request.httpBody = bodyString.data(using: .utf8)
            
                print("request: \(reqUrl)")
                request.httpMethod = "POST"
            request.setValue("Client-ID \(currentUser.clientID ?? "")", forHTTPHeaderField: "Authorization")
                request.addValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")

                let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                    if (error != nil){
                        print("error: \(error?.localizedDescription ?? "erorr")")
                        return
                    }
                    let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    print("response string: \(responseString!)")
                }
                task.resume()
            }
    }
    
    
    func uploadImageToImgur(image: UIImage) {
        let uploader = ImgurUploader(clientID: currentUser.clientID)
        uploader.upload(selectedImage) {
            result in
            switch result {
            case .success(let response):
                print("Success!")
                self.urlTextField.insertText(response.link.absoluteString)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
//               getBase64Image(image: image) { base64Image in
//                let boundary = "Boundary-\(UUID().uuidString)"
//
//                var request = URLRequest(url: URL(string: "https://api.imgur.com/3/image")!)
//                request.addValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
//                request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//                request.httpMethod = "POST"
//
//                let parameters = [
//                  [
//                    "key": "image",
//                    "value": "\(base64Image ?? "")",
//                    "type": "text"
//                  ],
//                  [
//                    "key": "title",
//                    "value": "\("DefaultTitle" ?? "")",
//                    "type": "text"
//                  ],
//                  [
//                    "key": "privacy",
//                    "value": "publish",
//                    "type": "text"
//                  ]] as [[String : Any]]
//
//
//                var body = ""
//                for param in parameters {
//                    if param["disabled"] == nil {
//                      let paramName = param["key"]!
//                      body += "--\(boundary)\r\n"
//                      body += "Content-Disposition:form-data; name=\"\(paramName)\""
//                      let paramType = param["type"] as! String
//                      if paramType == "text" {
//                        let paramValue = param["value"] as! String
//                        body += "\r\n\r\n\(paramValue)\r\n"
//                      } else {
//                        let paramSrc = param["src"] as! String
//                        guard let fileData = try? NSData(contentsOfFile:paramSrc, options:[]) as Data else { return }
//                        let fileContent = String(data: fileData, encoding: .utf8)!
//                        body += "; filename=\"\(paramSrc)\"\r\n"
//                          + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
//                      }
//                    }
//                }
//
//                body += "--\(boundary)--\r\n"
//                let postData = body.data(using: .utf8)
//
//
//                request.httpBody = postData
//
//
//                URLSession.shared.dataTask(with: request) { data, response, error in
//                    if let error = error {
//                        print("failed with error: \(error)")
//                        return
//                    }
//                    guard let response = response as? HTTPURLResponse,
//                        (200...299).contains(response.statusCode) else {
//                        print("server error")
//                        return
//                    }
//                    if let mimeType = response.mimeType, mimeType == "application/json", let data = data, let dataString = String(data: data, encoding: .utf8) {
//
//                        print("imgur upload results: \(dataString)")
//
//                        let parsedResult: [String: AnyObject]
//
//                        do {
//                            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
//                            if let dataJson = parsedResult["data"] as? [String: Any] {
//                                print("Link is : \(dataJson["link"] as? String ?? "Link not found")")
//                            }
//                        } catch {
//                            // Display an error
//                        }
//                    }
//                }.resume()
//            }
    }
    
//    private func uploadImageToImgur(image: UIImage) {
//        getBase64Image(image: image) { base64Image in
//            let boundary = "Boundary-\(UUID().uuidString)"
//                       var request = URLRequest(url: URL(string: "https://api.imgur.com/3/upload")!)
//                       request.addValue("Bearer \(self.accessToken)", forHTTPHeaderField: "Authorization")
//                       request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//                       request.httpMethod = "POST"
//
//
//                       var body = ""
//                       body += "--\(boundary)\r\n"
//                       body += "Content-Disposition:form-data; name=\"image\""
//                       body += "\r\n\r\n\(base64Image ?? "")\r\n"
//                       body += "--\(boundary)--\r\n"
//                       let postData = body.data(using: .utf8)
//
//                       request.httpBody = postData
//
//
//            URLSession.shared.dataTask(with: request) { data, response, error in
//                            if let error = error {
//                                print("failed with error: \(error)")
//                                return
//                            }
//                            guard let response = response as? HTTPURLResponse,
//                                (200...299).contains(response.statusCode) else {
//                                let response = response as? HTTPURLResponse
//                                print(response?.statusCode)
//                                print("server error")
//                                return
//                            }
//                            if let mimeType = response.mimeType, mimeType == "application/json", let data = data, let dataString = String(data: data, encoding: .utf8) {
//                                print("imgur upload results: \(dataString)")
//
//                                let parsedResult: [String: AnyObject]
//                                do {
//                                    parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
//                                    if let dataJson = parsedResult["data"] as? [String: Any] {
//                                        print("Link is : \(dataJson["link"] as? String ?? "Link not found")")
//                                        self.urlTextField.text = dataJson["link"] as? String
//                                    }
//                                } catch {
//                                    // Display an error
//                                }
//                            }
//                        }.resume()
//        }
//    }
    
    private func getBase64Image(image: UIImage, complete: @escaping (String?) -> ()) {
            DispatchQueue.main.async {
                let imageData = image.pngData()
                let base64Image = imageData?.base64EncodedString(options: .lineLength64Characters)
                complete(base64Image)
            }
        }
    
}

extension UploadViewController: UIImagePickerControllerDelegate {
    
    func presentImagePicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
            }
        self.selectedImage = image
        self.imageView.image = image
    }
}

