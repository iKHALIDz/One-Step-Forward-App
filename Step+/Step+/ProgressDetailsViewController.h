//
//  ProgressDetailsViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/8/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Progress.h"
#import "User.h"
#import "timelinePostComment.h"
#import "TimelinePostCommentTableViewCell.h"
#import "UserProfileViewController.h"


@interface ProgressDetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) Progress *currentProgress;
@property (nonatomic,strong) User *currentUser;

@property (weak, nonatomic) IBOutlet UILabel *progressDescription;

@property (weak, nonatomic) IBOutlet UILabel *stepOrderTextField;
@property (weak, nonatomic) IBOutlet UILabel *progressDateTextFiled;

@property (weak, nonatomic) IBOutlet UILabel *progressPercentageTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (nonatomic,strong) NSMutableArray *sPosts;


@end
