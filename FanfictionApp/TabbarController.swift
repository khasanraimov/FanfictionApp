//
//  TabbarController.swift
//  FanfictionApp
//
//  Created by khasan on 18.05.2023.
//

import UIKit

class TabbarController: UITabBarController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Removing the previous screen from the navigation stack
        self.navigationController?.viewControllers = [self]
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard UserDefaults.standard.string(forKey: "nickname") != nil else { return }
        guard UserDefaults.standard.string(forKey: "email") != nil else { return }
        
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
