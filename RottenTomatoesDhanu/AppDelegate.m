//
//  AppDelegate.m
//  RottenTomatoesDhanu
//
//  Created by Dhanu Agnihotri on 2/4/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "AppDelegate.h"
#import "MoviesViewController.h"
#import "DVDViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    //movies view controller
    MoviesViewController *moviesVC = [[MoviesViewController alloc] init];
    UINavigationController *ncMovie = [[UINavigationController alloc] initWithRootViewController:moviesVC];
    ncMovie.navigationBar.barTintColor = [UIColor blackColor];
    ncMovie.navigationBar.alpha = 0.1;
    ncMovie.navigationBar.tintColor = [UIColor orangeColor];
    ncMovie.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor]};
    
    //DVDs view controller
    DVDViewController *dvdVC = [[DVDViewController alloc] init];
    UINavigationController *ncDVD = [[UINavigationController alloc] initWithRootViewController:dvdVC];
    ncDVD.navigationBar.barTintColor = [UIColor blackColor];
    ncDVD.navigationBar.alpha = 0.1;
    ncDVD.navigationBar.tintColor = [UIColor orangeColor];
    ncDVD.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor]};
    
    NSArray *myViewControllers = [[NSArray alloc] initWithObjects:
                                  ncMovie,
                                  ncDVD, nil];
    
    //initialize the tab bar controller
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    //set the view controllers for the tab bar controller
    tabBarController.viewControllers = myViewControllers;
    tabBarController.tabBar.barTintColor = [UIColor blackColor];
    tabBarController.tabBar.tintColor = [UIColor orangeColor];
    
    self.window.rootViewController = tabBarController;
    
    //can't set this until after its added to the tab bar
    ncMovie.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"Movies"
                                  image:[UIImage imageNamed:@"Movies"]
                                    tag:1];
    ncDVD.tabBarItem =
    [[UITabBarItem alloc] initWithTitle:@"DVDs"
                                  image:[UIImage imageNamed:@"DVDs"]
                                    tag:2];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
