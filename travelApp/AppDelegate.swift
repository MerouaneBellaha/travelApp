import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    lazy var coreDataStack = CoreDataStack(containerName: "travelApp")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let tabBarController = window?.rootViewController as? UITabBarController,
            let navController = tabBarController.viewControllers?.first as? UINavigationController,
            let mainVC = navController.topViewController as? ConverterVC else{
            fatalError("Can't reach the Storyboard")
        }
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        mainVC.coreDataManager = CoreDataManager(with: appDelegate.coreDataStack)
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        coreDataStack.saveContext()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        coreDataStack.saveContext()
    }
}
