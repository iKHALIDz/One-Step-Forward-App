//
//  MainMenuViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 3/21/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"
#import <Parse/Parse.h>
#import "LoginViewController.h"
#import "InProgressGoalsViewController.h"
#import "TimelineViewController.h"


@interface MainMenuViewController : UIViewController

@property (nonatomic,strong) User *currentUser;


@property (weak, nonatomic) IBOutlet UIImageView *img;

@property (weak, nonatomic) IBOutlet UILabel *NumberInProgressGoals;

@property (weak, nonatomic) IBOutlet UILabel* NumberAchievedGoals;

@property (weak, nonatomic) IBOutlet UILabel *userFullname;



@end
