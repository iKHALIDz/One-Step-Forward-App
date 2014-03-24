//
//  AppDelegate.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/8/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [Parse setApplicationId:@"KmacqhkEK38ZSbv51RbVEH40m3xdo7hoBc33yJQz" clientKey:@"luIx9XAQ1KIvwrkrS5PorZY9tsvWVC5Xdbp7H93v"];
    
    PFUser *curreUser = [PFUser currentUser];
    
    if (curreUser)
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        MainMenuViewController *mainMenuViewController = (MainMenuViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"MainMenuViewController"];
        self.window.rootViewController = mainMenuViewController;
    }

    else
    {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        WelcomeViewController *wViewController = (WelcomeViewController *)[mainStoryboard instantiateViewControllerWithIdentifier:@"WelcomeViewController"];
        self.window.rootViewController = wViewController;
    }
    
    
    FMDatabase *db=[FMDatabase databaseWithPath:[[self DataFilePath] stringByAppendingPathComponent:@"Database.sqlite"]];
    BOOL isOpen=[db open];
    if (isOpen==NO)
    {
        NSLog(@"Fail to open");
        
    }
    
    NSString *createSQL= @"create table IF NOT exists Goals(goalId integer primary key,GoalName text, GoalDesc text, GoalDeadline text, isGoalCompleted integer, isGoalinPregress integer, goalPercentage REAL,CreatedBy text,goalDate text,numberofStepTaken int);";
    [db executeUpdate:createSQL];
    
    
    NSString *createSQL2= @"create table IF NOT exists Users(userId integer primary key,userFirstname text, userLastname text, userUsername text, userPassword text, userEmailAddress text, userProfileImage blob);";
    
    [db executeUpdate:createSQL2];

    
    NSString *createSQL3= @"create table IF NOT exists Progress(progressID integer primary key, progressDescription text, progressPercentageToGoal REAL, goalID integer,progressDate text,createdBy int);";
    
    [db executeUpdate:createSQL3];
    
    NSString *createSQL4= @"create table IF NOT exists Logs(logID integer primary key, userID integer, logDate text,LogContent text, logType text,logAction text);";
    
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
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
