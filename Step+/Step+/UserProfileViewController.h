//
//  UserProfileViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "Goal.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"
#import "goalTableViewCell.h"
#import "TimelinePost.h"
#import "UserProfileViewControllerDetailsViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "AMPAvatarView.h"

@interface UserProfileViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *NumberInProgressGoals;
@property (weak, nonatomic) IBOutlet UILabel* NumberAchievedGoals;
@property (weak, nonatomic) IBOutlet UILabel *userFullname;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) NSString *selectedUsername;
@property(nonatomic,retain) NSMutableArray *inProgressArrayFromParse;
@property (nonatomic,strong) MDRadialProgressView *radialView;
@property (nonatomic,strong) Goal* currentGoal;
@property (nonatomic,strong) User *currentUser;
@property (nonatomic,strong) User *selectedUser;
@property (strong, nonatomic) AMPAvatarView *avatar;

@property (weak, nonatomic) IBOutlet UIImageView *background;

@property (weak, nonatomic) IBOutlet UIView *profileview;


@end
