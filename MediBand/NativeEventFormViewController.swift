





import XLForm

class NativeEventFormViewController : XLFormViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    private enum Tags : String {
        
        case emptyname = "emptyname"
        case forename = "forename"
        case surname = "surname"
        case gpID = "gpID"
        case memberID = "memberID"
        case email = "email"
        case role = "role"
        case specialist = "specialist"

    }


    let constants = Contants()
    var staffImageView:UIImageView!
    var imagePicker = UIImagePickerController()
    var isUpdatingStaff = false
    var staff = Staff()
    var staffImage:UIImage?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeForm()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initializeForm()
    }


    func initializeForm() {
        
        let form : XLFormDescriptor
        var section : XLFormSectionDescriptor
        var row : XLFormRowDescriptor

        
        form = XLFormDescriptor(title: "Patient Form")
        
        section = XLFormSectionDescriptor.formSection()
        form.addFormSection(section)
        
        
        // Empty
        row = XLFormRowDescriptor(tag: "empty", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = ""
        row.required = false
        section.addFormRow(row)
        
        // Empty
        row = XLFormRowDescriptor(tag: "empty", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = ""
        row.required = false
        section.addFormRow(row)
        
        // Empty
        row = XLFormRowDescriptor(tag: "empty", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = ""
        row.required = false
        section.addFormRow(row)
        
        // Surname
        row = XLFormRowDescriptor(tag: "surname", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Surname"
        row.required = true
        section.addFormRow(row)
        
        // Forename
        row = XLFormRowDescriptor(tag: "forename", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Forename"
        section.addFormRow(row)
        
        // Email
        row = XLFormRowDescriptor(tag: "email", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Email"
        row.required = true
        section.addFormRow(row)
        
        // GP
        row = XLFormRowDescriptor(tag: "gpID", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "GP"
        row.required = true
        section.addFormRow(row)
        
        // staff ID
        row = XLFormRowDescriptor(tag: "memberID", rowType: XLFormRowDescriptorTypeText)
        row.cellConfigAtConfigure["textField.placeholder"] = "Staff ID"
        row.required = true
        section.addFormRow(row)
        
        // Role Status
        row = XLFormRowDescriptor(tag: "role", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Role")
        row.value = XLFormOptionsObject(value: 1, displayText: "Doctor")
        row.selectorTitle = "Doctor"
        row.selectorOptions = [XLFormOptionsObject(value: 0, displayText:"Doctor"),
                              XLFormOptionsObject(value: 1, displayText:"Nurse"),
                            XLFormOptionsObject(value: 2, displayText:"Allied Health Profession"),
            XLFormOptionsObject(value: 3, displayText:"Admin"),
            
        ]
        row.required = true
        section.addFormRow(row)
        
        // Specialist
        row = XLFormRowDescriptor(tag: "specialist", rowType:XLFormRowDescriptorTypeSelectorPush, title:"Specialist")
        row.value = constants.specialist[0]
        row.selectorTitle = "Doctor"
        row.selectorOptions = constants.specialist
        row.required = true
        section.addFormRow(row)
        
        self.form = form
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
        let topView:UIView = UIView(frame: CGRectMake(0, 0, view.frame.size.width, 160))
        topView.backgroundColor = UIColor.whiteColor()
        
        staffImageView = UIImageView(frame: CGRectMake((view.frame.size.width - 220)/2, 25, 100, 100))
        
        staffImageView.clipsToBounds = true
        staffImageView.layer.cornerRadius = 100/2
        staffImageView.image = UIImage(named: "defaultImage")
        topView.addSubview(staffImageView)
        
        let uploadImgBtn:UIButton = UIButton()
        uploadImgBtn.frame.size = CGSizeMake(120, 30)
        uploadImgBtn.center.y = staffImageView.center.y + 30
        uploadImgBtn.frame.origin.x = 180
        uploadImgBtn.setTitle("UPLOAD PIC", forState: UIControlState.Normal)
        uploadImgBtn.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        uploadImgBtn.addTarget(self, action: "pressed:", forControlEvents: .TouchUpInside)
        uploadImgBtn.backgroundColor = UIColor(red: 0.16, green: 0.89, blue: 0.98, alpha: 1)
        uploadImgBtn.layer.cornerRadius = 5
        uploadImgBtn.clipsToBounds = true
        
        topView.addSubview(uploadImgBtn)
        self.tableView.addSubview(topView)
    }
    
    func pressed(sender: UIButton!) {
        println("upload")
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("done")
        })
        self.staffImage = image
        staffImageView.image = image
    }
    

// MARK: XLFormDescriptorDelegate

    override func formRowDescriptorValueHasChanged(formRow: XLFormRowDescriptor!, oldValue: AnyObject!, newValue: AnyObject!) {
        super.formRowDescriptorValueHasChanged(formRow, oldValue: oldValue, newValue: newValue)


    }



}