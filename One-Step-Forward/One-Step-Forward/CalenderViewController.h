//
//  CalenderViewController.h
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RDVCalendarView.h"


@protocol passDate <NSObject>

-(void)setDeadline:(NSString*)deadline;

@end

@interface CalenderViewController : UIViewController <RDVCalendarViewDelegate>

@property (nonatomic, strong) RDVCalendarView *calendarView;
@property (nonatomic) BOOL clearsSelectionOnViewWillAppear;

@property (weak, nonatomic) IBOutlet UIView *CalenderView;
- (IBAction)doneisPressed:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSString *selctedDate;

@property (retain) id <passDate> delegate;
@property (nonatomic,retain) NSString *deadlinetext;


@end