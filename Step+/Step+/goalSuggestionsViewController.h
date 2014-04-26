//
//  goalSuggestionsViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/8/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Goal.h"
#import "User.h"
#import "timelinePostComment.h"
#import "TimelinePostCommentTableViewCell.h"
#import "UserProfileViewController.h"
#import "AMPAvatarView.h"
#import <QuartzCore/QuartzCore.h>

@interface goalSuggestionsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *goalNameLable;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) Goal *currentGoal;

@property (nonatomic,strong) User *currentUser;

@property (nonatomic,strong) NSMutableArray *sPosts;
@property (strong, nonatomic) AMPAvatarView *avatar2;

@end
