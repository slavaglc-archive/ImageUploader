 
 
 class Joke {
    var categories = [String]()
         var id: Int?
         var joke: String?
    
    init(json: [String: Any]) {
        self.joke = json["joke"] as? String
        self.id = json["id"] as? Int
        self.categories = json["categories"] as! [String]
    }
 }
