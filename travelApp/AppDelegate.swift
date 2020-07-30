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
        guard let secondNavController = tabBarController.viewControllers?.last as? UINavigationController,
            let settingsVc = secondNavController.topViewController as? SettingsVC else {
            fatalError("Can't reach the Storyboard / settingsVC")
        }

        guard let forthNavController = tabBarController.viewControllers?[3] as? UINavigationController,
            let toDoVC = forthNavController.topViewController as? ToDoVC else {
                fatalError("Can't reach the Storyboard / toDoVC")
        }

        tabBarController.viewControllers?.forEach { navigationController in
            (navigationController as? UINavigationController)?.topViewController?.setSwipe()
        }

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        mainVC.coreDataManager = CoreDataManager(with: appDelegate.coreDataStack)
        settingsVc.coreDataManager = CoreDataManager(with: appDelegate.coreDataStack)
        toDoVC.coreDataManager = CoreDataManager(with: appDelegate.coreDataStack)

        GMSPlacesClient.provideAPIKey(K.googleKey)

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0.2215721905, green: 0.3624178171, blue: 0.4913087487, alpha: 1)

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
}
