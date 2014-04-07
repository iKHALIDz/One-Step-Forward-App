//
//  timelineCell.h
//  Step+
//
//  Created by KHALID ALAHMARI on 4/7/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface timelineCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *timedate;

@property (weak, nonatomic) IBOutlet UIImageView *userpic;


@property (weak, nonatomic) IBOutlet UILabel *postContent;

- (IBAction)comment:(UIButton *)sender;



@end
