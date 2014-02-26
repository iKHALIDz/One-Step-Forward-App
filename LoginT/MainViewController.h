//
//  MainViewController.h
//  LoginT
//
//  Created by KHALID ALAHMARI on 2/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface MainViewController : UIViewController <NSFetchedResultsControllerDelegate>



@property (nonatomic,strong) User *user;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

- (IBAction)press:(id)sender;



@end
