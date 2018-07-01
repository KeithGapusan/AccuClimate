//
//  CustomLoader
//
//
//  Created by Keith Gapusan on 01/10/2017.
//  Copyright © 2017 Keith Randell Gapusan. All rights reserved.
//



import UIKit


class CustomLoader: UIViewController {
    
    class func instanceFromNib() -> UIViewController {
        return UINib(nibName: xibName.customLoader, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIViewController
    }
}
