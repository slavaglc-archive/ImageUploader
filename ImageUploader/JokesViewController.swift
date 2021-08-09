

import UIKit

class JokesViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var jokeTextView: UITextView!
    
    var currentJoke: String!
    var jokes = [Joke]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        parseJoke()
    }
    
    @IBAction func newJokeTapped() {
        parseJoke()
    }
    
    private func parseJoke() {
        startIndicator()
        let url = URL(string: "http://api.icndb.com/jokes/random")
        URLSession.shared.dataTask(with:url!, completionHandler: { [self](data, response, error) in
                    guard let data = data, error == nil else { return }
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        let value = json["value"] as! [String: Any]
                        let jokeObject = Joke(json: value)
                        self.currentJoke = jokeObject.joke
                        DispatchQueue.main.async {
                            self.jokeTextView.text = currentJoke
                            stopIndicator()
                        }
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }).resume()
        
    }
    
    private func startIndicator() {
        jokeTextView.isHidden = true
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func stopIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        jokeTextView.isHidden = false
    }
}
