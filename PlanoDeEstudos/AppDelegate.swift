import UIKit
import UserNotifications

//https://medium.com/swlh/simulating-push-notifications-in-ios-simulator-9e5198bed4a4
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        self.center.delegate = self
        
        center.getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
            case .notDetermined:
                let options: UNAuthorizationOptions = [.alert, .badge, .sound, .carPlay]
                self.center.requestAuthorization(options: options) { (authorized, error) in
                    print("Status da autorização:", authorized)
                }
            default:
                break
            }
        }
        application.registerForRemoteNotifications()
        let confirmAction = UNNotificationAction(identifier: "confirm", title: "Já estudei 👍", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "cancel", title: "Cancelar", options: [])
        let category = UNNotificationCategory(identifier: "Lembrete", actions: [confirmAction, cancelAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: [.customDismissAction])
        center.setNotificationCategories([category])
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken.reduce(""){$0 + String(format: "%02x", $1)})
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Erro")
    }
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .badge, .alert])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        let id = response.notification.request.identifier
        print(id)
        
        switch response.actionIdentifier {
        case "confirm":
            print("Usuário confirmou que já estudou a matéria \(response.notification.request.content.title)")
            StudyManager.shared.setPlanDone(id: id)
        case "cancel":
            print("Usuário cancelou")
        case UNNotificationDefaultActionIdentifier:
            print("Usuário tocou na notificação em si")
        case UNNotificationDismissActionIdentifier:
            print("Usuário dismissou a notificação")
        default:
            print("Outro cenário")
        }
        completionHandler()
    }
}
