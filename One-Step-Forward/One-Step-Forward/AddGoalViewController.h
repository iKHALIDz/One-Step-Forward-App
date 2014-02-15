//
//  AddGoalViewController.h
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/13/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface AddGoalViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *goalName;

@property (weak, nonatomic) IBOutlet UITextField *goalDesc;

- (IBAction)isSavePressed:(UIBarButtonItem *)sender;


@end
