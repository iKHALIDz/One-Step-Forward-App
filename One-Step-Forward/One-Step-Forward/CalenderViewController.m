//  CalenderViewController.m
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "CalenderViewController.h"
#import "AddGoalViewController.h"


@interface CalenderViewController ()

@end

@implementation CalenderViewController

@synthesize calendar,dateFormatter,selctedDate,delegate,deadlinetext;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    calendar = [[CKCalendarView alloc] init];
    [self.CalenderView addSubview:calendar];
    
    calendar.delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"dd/MM/yyyy"];

	// Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)calendar:(CKCalendarView *)calendar didSelectDate:(NSDate *)date
{
    
    selctedDate=[self.dateFormatter stringFromDate:date];
    NSLog(@"%@",selctedDate);
}


- (IBAction)doneisPressed:(UIBarButtonItem *)sender {
    NSLog(@"Done is Pressed");
    
    [[self delegate]setDeadline:self.selctedDate];
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end
