//
//  CalenderViewController.h
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CKCalendarView.h"



@protocol SDProtocol <NSObject>

-(void) secondViewControllerDismissed:(NSString *)stringForFirst;

@end


@interface CalenderViewController : UIViewController <CKCalendarDelegate>


@property (nonatomic, assign) id <SDProtocol> myDelegate;

@property(nonatomic, strong) CKCalendarView *calendar;

@property (weak, nonatomic) IBOutlet UIView *CalenderView;

- (IBAction)doneisPressed:(UIBarButtonItem *)sender;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSString *selctedDate;


@end
