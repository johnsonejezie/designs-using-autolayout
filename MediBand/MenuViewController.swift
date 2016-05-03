//
//  MenuViewController.swift
//  MediBand
//
//  Created by Kehinde Shittu on 7/27/15.
//  Copyright (c) 2015 Johnson Ejezie. All rights reserved.
//

import UIKit
protocol menuViewControllerDelegate: class {
    func menuViewResponse(controller: MenuViewController,
        didDismissPopupView selectedCell: Int)
}
class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

  
    weak var delegate: menuViewControllerDelegate!
    @IBOutlet var optionsTable: UITableView!
    var selectedCell:Int = 1;
    
    let options : [AnyObject] = Contants().resolution;
    override func viewDidLoad() {
        super.viewDidLoad()
        self.optionsTable.delegate = self
        self.optionsTable.dataSource = self
        self.optionsTable.backgroundColor = sharedDataSingleton.theme
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("OptionsCell", forIndexPath: indexPath) 
        cell.textLabel?.text = options[indexPath.row] as? String
        var detailsView = ActivityDetailsViewController()
        if indexPath.row == selectedCell{
        cell.backgroundColor = UIColor.whiteColor()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.dismissViewControllerAnimated(true, completion: nil)
        delegate?.menuViewResponse(self, didDismissPopupView: indexPath.row);
    }
    
   
    
}
