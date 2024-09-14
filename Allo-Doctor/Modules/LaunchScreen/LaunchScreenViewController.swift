//
//  LaunchScreenViewController.swift
//  Allo-Doctor
//
//  Created by Abdallah ismail on 02/09/2024.
//

import UIKit
import Reachability
class LaunchScreenViewController: UIViewController {
   
    @IBOutlet weak var loadingGif: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loadingimage = UIImage.gifImageWithName("loading")
        loadingGif?.image = loadingimage 
    }


}
