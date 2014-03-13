//
//  progressTableViewCell.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/26/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface progressTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *progressName;

@property (weak, nonatomic) IBOutlet UILabel *progressPercentage;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;


@end
