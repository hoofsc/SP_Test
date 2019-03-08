//
//  OfficeCollectionViewCell.swift
//  SP_Test
//
//  Created by Hoof on 3/4/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class OfficeCollectionViewCell: UICollectionViewCell {
    
    let kMapRegionDistance = 5000
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var cityStateZipLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    
    var office: Office? {
        didSet {
            guard office != nil,
                let name = office?.name,
                let street = office?.street,
                let city = office?.city,
                let state = office?.state,
                let zip = office?.zip,
                let phone = office?.phone else {
                return
            }
            nameLabel.text = name
            streetLabel.text = street
            cityStateZipLabel.text = "\(city), \(state) \(zip)"
            phoneLabel.text = phone
            
            if let geoLocation = office!.geoLocation {
                let coordinate = geoLocation.location.coordinate
                let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: CLLocationDistance(exactly: kMapRegionDistance)!, longitudinalMeters: CLLocationDistance(exactly: kMapRegionDistance)!)
                mapView.setRegion(mapView.regionThatFits(region), animated: false)
                let anno = MKPointAnnotation()
                anno.coordinate = coordinate
                mapView.addAnnotation(anno)
            } else {
                print("geolocation not found")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        mapView.isUserInteractionEnabled = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 5.0
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 3.0
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
        layer.backgroundColor = UIColor.clear.cgColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nameLabel.text = ""
        streetLabel.text = ""
        cityStateZipLabel.text = ""
        phoneLabel.text = ""
    }
    
}

extension OfficeCollectionViewCell: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        let reuseId = "pinAnnotationView"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.pinTintColor = .purple
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
}
