//
//  ViewController.h
//  AppUsingParseCloud
//
//  Created by KHALID ALAHMARI on 1/22/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"


@interface ViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *UsernameText;

@end
