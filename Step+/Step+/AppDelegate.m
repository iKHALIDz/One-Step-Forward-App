//
//  AppDelegate.m
//  Step+
//
//  Created by KHALID ALAHMARI on 3/20/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "MainMenuViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"KmacqhkEK38ZSbv51RbVEH40m3xdo7hoBc33yJQz" clientKey:@"luIx9XAQ1KIvwrkrS5PorZY9tsvWVC5Xdbp7H93v"];
    
    PFUser *curreUser = [PFUser currentUser];
    
    if (curreUser)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"main" bundle: nil];
        MainMenuViewController *mainMenuViewController = (MainMenuViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
        self.window.rootViewController = mainMenuViewController;
    }
    
    else
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"main" bundle: nil];
        LoginViewController*wViewController = (LoginViewController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        self.window.rootViewController = wViewController;
    }
    
    
    NSString *createSQL1= @"create table IF NOT exists Users(userId integer,userFirstname text, userLastname text, userUsername text primary key, userPassword text, userEmailAddress text, userProfileImage blob,numberOfInProgressGoals int,numberOfAchievedGoals int,wantsToShare int);";
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    [db executeUpdate:createSQL1];
    

    NSString *createSQL= @"create table IF NOT exists Goals(goalId integer,GoalName text, GoalDesc text, GoalDeadline text, isGoalCompleted integer, isGoalinPregress integer, goalPercentage REAL,CreatedBy text,goalDate text,numberofStepTaken int,goalType text,goalpriority int);";
    
    [db executeUpdate:createSQL];
    
    NSString *createSQL3= @"create table IF NOT exists Progress(progressID integer, progressDescription text, progressPercentageToGoal REAL, goalID integer,progressDate text,createdBy text,stepOrder int);";
    
    [db executeUpdate:createSQL3];

    
    NSString *createSQL4= @"create table IF NOT exists Logs(logID integer, userUsername text, logDate text,LogContent text, logType text,logAction text,month int,year int);";
    
    [db executeUpdate:createSQL4];

    
    
    return YES;
}



-(NSString*)DataFilePath
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Step_" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Step_.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    NSLog(@"Here");
    UILocalNotification *newNotification = notification;
    notification.fireDate = [NSDate dateWithTimeInterval:3600 sinceDate:notification.fireDate];
    notification.repeatInterval = 0;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
    
}

@end
