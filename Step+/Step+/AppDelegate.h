//
//  AppDelegate.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/20/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
