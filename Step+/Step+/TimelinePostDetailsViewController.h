//
//  TimelinePostDetailsViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelinePost.h"
#import <Parse/Parse.h>
#import "User.h"
#import "TimelinePostCommentTableViewCell.h"
#import "timelinePostComment.h"
#import "UserProfileViewController.h"



@interface TimelinePostDetailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *postusername;
@property (strong, nonatomic) IBOutlet UILabel *userPostDate;

@property (weak, nonatomic) IBOutlet UIImageView *userpic;

@property (weak, nonatomic) IBOutlet UILabel *postContent;

@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (weak, nonatomic) IBOutlet UIButton *sendComment;

@property (nonatomic,retain) TimelinePost *currentSelectedtimeLinePost;

- (IBAction)sendComment:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic,strong) User *currentUser;

@property (nonatomic,strong) NSMutableArray *TimelinePostComments;

@property (nonatomic,retain) NSString *currentUsername;


@end
