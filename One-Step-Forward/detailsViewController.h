//
//  detailsViewController.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/21/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "progressTableViewCell.h"
#import "AddProgressViewController.h"


@interface detailsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,updateGoalPercentage>


- (IBAction) declareAchieved:(UIButton *)sender;

@property (nonatomic,retain) NSString *currentGoalID;
@property double currentGoalProgressPercentage;

@property (nonatomic, strong) NSArray *postArray;

//
//- (IBAction)addProgress:(UIButton *)sender;
//
//@property (weak, nonatomic) IBOutlet UITextField *progressTextField;
//
//@property (weak, nonatomic) IBOutlet UITextField *progressPercentage;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSArray *doneProgress;


@end
