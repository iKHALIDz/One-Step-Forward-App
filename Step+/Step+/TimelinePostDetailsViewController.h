//
//  TimelinePostDetailsViewController.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TimelinePost.h"

@interface TimelinePostDetailsViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *postusername;
@property (strong, nonatomic) IBOutlet UILabel *userPostDate;

@property (weak, nonatomic) IBOutlet UIImageView *userpic;

@property (weak, nonatomic) IBOutlet UILabel *postContent;

@property (weak, nonatomic) IBOutlet UITextField *commentTextField;

@property (weak, nonatomic) IBOutlet UIButton *sendComment;

@property (nonatomic,retain) TimelinePost *currentSelectedtimeLinePost;


@end
