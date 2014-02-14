//
//  userGoals.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/13/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "goalTableViewCell.h"


@interface userGoals : UITableView

@property (nonatomic,strong) NSMutableArray *goalsName;
@property (nonatomic,strong) NSMutableArray *goalsdescription;
@property (nonatomic,strong) NSMutableArray *goalDeadline;


@end
