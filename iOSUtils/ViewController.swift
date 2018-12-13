import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btnTest: UIButton!
    @IBOutlet weak var tvTest: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func clickBtnTest(_ sender: UIButton) {
        PermissionUtils.init().jumpToSetting(controller: self, title: "fdsa", message: "fdsafdsa", defaultAction: "去设置", isJumpToSetting: true, cancelAction: "取消")
    }
    
}
