//
//  MapViewController.swift
//  SampleApp
//
//  Created by apple on 09/05/21.
//

import UIKit
import GoogleMaps
import Multisearch

class MapViewController: UIViewController {
    @IBOutlet weak var googleMapView: GMSMapView!
    var  detailsResponseItem: DetailsResponseItem?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let detailsResponseItem = detailsResponseItem {
            if let geometry = detailsResponseItem.geometry {
                self.googleMapView.camera = GMSCameraPosition(
                    target: CLLocationCoordinate2D(latitude: geometry.location.lat, longitude: geometry.location.lng),
                      zoom: 14,
                      bearing: 0,
                      viewingAngle: 0)

                let markerPoint = GMSMarker.init(position: CLLocationCoordinate2D(latitude: geometry.location.lat, longitude: geometry.location.lng))
                markerPoint.map = self.googleMapView
                markerPoint.title = detailsResponseItem.name
                markerPoint.snippet = detailsResponseItem.formattedAddress
                self.googleMapView.selectedMarker = markerPoint
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @IBAction func onTapShowDetails(_ sender: UIButton) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let mapViewController = storyBoard.instantiateViewController(withIdentifier: "ID_MAPDETAILS") as? JSONViewController {
            mapViewController.detailsResponseItem = detailsResponseItem
            self.navigationController?.pushViewController(mapViewController, animated: true)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
