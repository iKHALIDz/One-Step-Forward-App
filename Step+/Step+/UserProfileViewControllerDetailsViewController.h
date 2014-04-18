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

@interface UserProfileViewControllerDetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) Goal* cgoal;

@property (weak, nonatomic) IBOutlet UITextField *suggestionTextField;
- (IBAction)send:(UIButton *)sender;

@property (nonatomic,strong) User *currentUser;

@end

