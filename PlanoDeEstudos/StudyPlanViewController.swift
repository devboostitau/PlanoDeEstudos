import UIKit
import UserNotifications

class StudyPlanViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tfCourse: UITextField!
    @IBOutlet weak var tfSection: UITextField!
    @IBOutlet weak var dpDate: UIDatePicker!
    
    // MARK: - Properties
    let sm = StudyManager.shared
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dpDate.minimumDate = Date()
    }

    // MARK: - IBActions
    @IBAction func schedule(_ sender: UIButton) {
        let id = UUID().uuidString
        let studyPlan = StudyPlan(course: tfCourse.text!, section: tfSection.text!, date: dpDate.date, done: false, id: id)
        
        let content = UNMutableNotificationContent()
        content.title = "Lembrete:"
        content.subtitle = "Matéria: \(studyPlan.course)"
        content.body = "Estudar \(studyPlan.section)"
        content.sound = UNNotificationSound(named: UNNotificationSoundName("sonic.caf"))
        content.categoryIdentifier = "Lembrete"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
//        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .minute, .hour], from: dpDate.date)
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        sm.addPlan(studyPlan)
        navigationController!.popViewController(animated: true)
    }
    
}
