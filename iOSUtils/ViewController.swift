import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnTest: UIButton!
    @IBOutlet weak var tvTest: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let p = PermissionUtils.init(type: .Photo)
        
        p.request { (status) in
            print(status.rawValue)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func clickBtnTest(_ sender: UIButton) {
        
    }

}
