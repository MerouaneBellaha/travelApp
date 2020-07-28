import UIKit
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(containerName: "travelApp")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let navController = tabBarController.viewControllers?.first as? UINavigationController,
            let mainVC = navController.topViewController as? ConverterVC else {
            fatalError("Can't reach the Storyboard / mainVc")
        }

//        tabBarController.tabBar.shadowImage = UIImage()
//        tabBarController.tabBar.backgroundImage = UIImage()
//        tabBarController.tabBar.backgroundColor = UIColor.white

        guard let secondNavController = tabBarController.viewControllers?.last as? UINavigationController,
            let settingsVc = secondNavController.topViewController as? SettingsVC else {
            fatalError("Can't reach the Storyboard / settingsVC")
        }

        guard let forthNavController = tabBarController.viewControllers?[3] as? UINavigationController,
            let toDoVC = forthNavController.topViewController as? ToDoVC else {
                fatalError("Can't reach the Storyboard / toDoVC")
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        mainVC.coreDataManager = CoreDataManager(with: appDelegate.coreDataStack)
        settingsVc.coreDataManager = CoreDataManager(with: appDelegate.coreDataStack)
        toDoVC.coreDataManager = CoreDataManager(with: appDelegate.coreDataStack)

        GMSPlacesClient.provideAPIKey(K.googleKey)

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
}
