//
//  UsersTableViewController.swift


import XLForm
import Haneke

class UserCell : UITableViewCell {

    lazy var userImage : UIImageView = {
        let tempUserImage = UIImageView()
        tempUserImage.translatesAutoresizingMaskIntoConstraints = false
        tempUserImage.layer.masksToBounds = true
        tempUserImage.layer.cornerRadius = 10.0
        return tempUserImage
    }()

    
    lazy var userName : UILabel = {
        let tempUserName = UILabel()
        tempUserName.translatesAutoresizingMaskIntoConstraints = false
        tempUserName.font = UIFont.systemFontOfSize(15.0)
        return tempUserName
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        // Initialization code
    
        self.contentView.addSubview(self.userImage)
        self.contentView.addSubview(self.userName)
    
        self.contentView.addConstraints(self.layoutConstraints())
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
// MARK: - Layout Constraints

    func layoutConstraints() -> [NSLayoutConstraint]{
        let views = ["image": self.userImage, "name": self.userName ]
        let metrics = [ "imgSize": 50.0, "margin": 12.0]
        
        var result = NSLayoutConstraint.constraintsWithVisualFormat("H:|-(margin)-[image(imgSize)]-[name]", options:NSLayoutFormatOptions.AlignAllTop, metrics: metrics, views: views)
        result += NSLayoutConstraint.constraintsWithVisualFormat("V:|-(margin)-[image(imgSize)]", options:NSLayoutFormatOptions(), metrics:metrics, views: views)
        return result
    }
    
    
}



class UsersTableViewController : UITableViewController, XLFormRowDescriptorViewController, XLFormRowDescriptorPopoverViewController {
    
    var selected_staff_ids:[String] = []
    var selected_staff:[Staff] = []
    var filteredStaff:[Staff] = []
    
    var rowDescriptor : XLFormRowDescriptor?
    var popoverController : UIPopoverController?
    
    var userCell : UserCell?
    
    private let kUserCellIdentifier = "UserCell"
    
    
    override init(style: UITableViewStyle) {
        super.init(style: style);
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for staff in sharedDataSingleton.allStaffs {
            if staff.speciality == sharedDataSingleton.specialistFilterString {
                filteredStaff.append(staff)
            }
        }
        
        self.tableView.registerClass(UserCell.self, forCellReuseIdentifier: self.kUserCellIdentifier)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "savePressed:")
    }
    
    func savePressed(button: UIBarButtonItem)
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
// MARK: UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 1
        if filteredStaff.count > 0 {
            count = filteredStaff.count
        }
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UserCell = tableView.dequeueReusableCellWithIdentifier(self.kUserCellIdentifier, forIndexPath: indexPath) as! UserCell
        if filteredStaff.count > 0 {
            let usersData = filteredStaff
            let userData = usersData[indexPath.row] as Staff
            let userId = userData.id
            cell.userName.text = userData.firstname + " " + userData.surname
            
            cell.userImage.image = UIImage(named: "defaultImage")
            if userData.image != "" {
                let URL = NSURL(string: userData.image)!
//                cell.userImage.hnk_setImageFromURL(URL)
                
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
                    if let getImage =  UIImage(data: NSData(contentsOfURL:URL)!) {
                        dispatch_async(dispatch_get_main_queue()) {
                            cell.userImage.image = getImage
                    }
                   
                    }
                }
            }
            if sharedDataSingleton.selectedIDs.contains(userId) {
                cell.accessoryType = .Checkmark
            }else {
                cell.accessoryType = .None
            }
        }else {
            cell.userName.text = "No staff for specialist: \(sharedDataSingleton.specialistFilterString)"
        }
        
        return cell;

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 73.0
    }
    

//MARK: UITableViewDelegate

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.accessoryType == UITableViewCellAccessoryType.Checkmark {
            cell?.accessoryType = UITableViewCellAccessoryType.None
            let aStaff:Staff = filteredStaff[indexPath.row]
            let name:String = aStaff.firstname + " " + aStaff.surname
            self.removeObject(aStaff.id, fromArray: &selected_staff_ids)
            self.removeStaff(aStaff)
            self.rowDescriptor?.value = selected_staff_ids
            sharedDataSingleton.selectedIDs = selected_staff_ids

        }else {
            cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
            let aStaff:Staff = sharedDataSingleton.allStaffs[indexPath.row]
            let name:String = aStaff.firstname + " " + aStaff.surname
            selected_staff.append(aStaff)
            selected_staff_ids.append(aStaff.id)
             self.rowDescriptor?.value = selected_staff_ids
            sharedDataSingleton.selectedIDs = selected_staff_ids
        }
    }
    
    func removeObject<T : Equatable>(object: T, inout fromArray array: [T])
    {
        let index = array.indexOf(object)
        if let ind = index {
            array.removeAtIndex(ind)
        }
        
    }
    
    func removeStaff(aStaff:Staff) {
        for var i = 0; i < selected_staff.count; ++i {
            if aStaff.id == selected_staff[i].id {
                selected_staff.removeAtIndex(i)
            }
        }
    }
    
    
}
