//
//  UserProfileViewControllerDetailsViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/8/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"
#import "timelineCell.h"
#import "TimelinePost.h"
#import <Parse/Parse.h>
#import "User.h"
#import "Progress.h"
#import "ProgressTableViewCell.h"
#import "NSDate+PrettyDate.h"
#import "UIColor+ConvertHexToUIColor.h"
#import "ProgressTableViewCell.h"
#import "MDRadialProgressView.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"


@interface UserProfileViewControllerDetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) Goal* cgoal;

@property (weak, nonatomic) IBOutlet UITextField *suggestionTextField;

@property (weak, nonatomic) IBOutlet UILabel *goalName;

@property (weak, nonatomic) IBOutlet UILabel *goalDescription;

@property (weak, nonatomic) IBOutlet UILabel *stepTaken;

@property (weak, nonatomic) IBOutlet UIView *ProgressPercentage;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneOutlet;

- (IBAction)send:(UIBarButtonItem *)sender;

@property (nonatomic,strong) User *currentUser;

@property (weak, nonatomic) IBOutlet UITableView *progressListTable;

@property(nonatomic,retain) NSMutableArray *progressListFromParse;

@property (nonatomic,strong) MDRadialProgressView *radialView;

- (IBAction)BackISPressedisPre:(UIBarButtonItem *)sender;

@end

