//
//  ViewController.swift
//  DataPassingUsingSegue
//
//  Created by Yagnik Suthar on 02/01/19.
//  Copyright © 2019 ecosmob. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tblDataList: UITableView!
    var aryDic = [DataModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindToMainVC(segue:UIStoryboardSegue) {
        let sourceVC = segue.source as? SecondVC
        aryDic.append((sourceVC?.rawDic)!)
        tblDataList.reloadData()
    }
}

extension MainViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if aryDic.count > 0 {
            return aryDic.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath)  as! CustomCell
        let curRow = aryDic[indexPath.row]
        cell.lblTitle.text = curRow.name
        cell.lblDesc.text = curRow.date
        return cell
    }
    
    
}
