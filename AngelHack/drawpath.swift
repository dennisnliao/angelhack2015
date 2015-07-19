import UIKit
import GoogleMaps

/* This function takes a location ID and returns the calculated route
from the current user location to the location ID */
func GetPath(placeID: String, placesClient: GMSPlacesClient) -> CLLocationCoordinate2D? {
    var loc: CLLocationCoordinate2D?
    var err: NSError?

    //Call the lookup function and set the variables inside the anonymous function
    placesClient.lookUpPlaceID(placeID, callback: { (place, error) -> () in
        if error != nil {
            println("lookup place id query error: \(error!.localizedDescription)")
            err = error
            return
        }

        if place != nil {
            loc = place!.coordinate
        } else {
            return
        }
    })

    return loc
}
    
/* This function takes a GMSPlacesCLient type object and uses it to access the
current user location. It returns a CLLocationCoordinate2D type struct object with
the phone's location (Currently naively takes the last location in the list) */
func GetCurrentLoc(placesClient: GMSPlacesClient) -> CLLocationCoordinate2D? {
    var loc: CLLocationCoordinate2D?
    var err: NSError?

    placesClient.currentPlaceWithCallback({ (placeLikelihoods, error) -> Void in
      // Return nil if there was an error, print to logs
      if error != nil {
        println("Current Place error: \(error!.localizedDescription)")
        err = error
        return
      }

      // Right now we just set location to the last coordinate in the list
      for likelihood in placeLikelihoods!.likelihoods {
        if let likelihood = likelihood as? GMSPlaceLikelihood {
          let loc = likelihood.place.coordinate
        }
      }
    })
    return loc
}

func GetRoute(loc1: CLLocationCoordinate2D, loc2: CLLocationCoordinate2D) {
    var longitude1, longitude2, latitude1, latitude2: String
    var points = [CLLocationCoordinate2D]()
    var paths = [String]()

    //Convert all of the double type location values to strings to format in post request
    longitude1 = String(format:"%f", loc1.longitude)
    latitude1 = String(format:"%f", loc1.latitude)
    longitude2 = String(format:"%f", loc2.longitude)
    latitude2 = String(format:"%f", loc2.latitude)

    //Format final string as request to google routing api
    var url: String = "https://maps.googleapis.com/maps/api/directions/?origin=" + 
                  latitude1 + "," + longitude1 + "&destination=" + latitude2 +
                  "," + longitude2 + "&key=" + "AIzaSyBMAGsuA1aiKvVqXs1lHEEoes0U7K9h7nU" +
                  "&mode=walking"

    let nurl = NSURL(string: url)
    let data = NSData(contentsOfURL: nurl!)
    var error: NSError?
    let dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &error) as! NSDictionary
//    if dict != nil {
            var steps = dict["routes"]![0]!["legs"]![0]!["steps"]!

            points.append(CLLocationCoordinate2DMake(steps[0]["start_location"]["lat"], steps[0]["start_location"]["lng"]))
            for line in steps {
                points.append(CLLocationCoordinate2DMake(line["end_location"]["lat"], line["end_location"]["lng"]))
                paths.append(lines["polyline"]["points"])
//        }
//        } else {
//            println("JSON Error \(err.localizedDescription)")
//        }

    return (points?, paths?)
}


// func searchItunesFor(searchTerm: String) {
//     // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
//     let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
     
//     // Now escape anything else that isn't URL-friendly
//     if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
//         let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
//         let url = NSURL(string: urlPath)
//         let session = NSURLSession.sharedSession()
//         let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
//             println("Task completed")
//             if(error != nil) {
//                 // If there is an error in the web request, print it to the console
//                 println(error.localizedDescription)
//             }
//             var err: NSError?
//             if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
//                 if(err != nil) {
//                     // If there is an error parsing JSON, print it to the console
//                     println("JSON Error \(err!.localizedDescription)")
//                 }
//                 if let results: NSArray = jsonResult["results"] as? NSArray {
//                     dispatch_async(dispatch_get_main_queue(), {
//                         self.tableData = results
//                         self.appsTableView!.reloadData()
//                     })
//                 }
//             }
//         })
         
//         // The task is just an object with all these properties set
//         // In order to actually make the web request, we need to "resume"
//         task.resume()
//     }
// }