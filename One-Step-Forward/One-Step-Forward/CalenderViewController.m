//  CalenderViewController.m
//  CreateGoals
//
//  Created by KHALID ALAHMARI on 2/12/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "CalenderViewController.h"
#import "AddGoalViewController.h"


@interface CalenderViewController ()
{
    BOOL isSelectedData;
}

@end
@implementation CalenderViewController

@synthesize dateFormatter,selctedDate,delegate,deadlinetext;



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
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MM/dd/yyyy"];
    
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];
    _calendarView = [[RDVCalendarView alloc] initWithFrame:applicationFrame];
    [_calendarView setAutoresizingMask:UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight];
    [_calendarView setSeparatorStyle:RDVCalendarViewDayCellSeparatorTypeHorizontal];
    [_calendarView setBackgroundColor:[UIColor whiteColor]];
    [_calendarView setDelegate:self];
    
    [_calendarView setFrame:CGRectMake(3, 0, 320,360)];
    
    
    [self.CalenderView addSubview:self.calendarView];
    UIBarButtonItem *todayButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Today", nil)
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:[self calendarView]
                                                                   action:@selector(showCurrentMonth)];
    
    [self.navigationItem setLeftBarButtonItem:todayButton];

	// Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    
    self.doneButton.enabled = NO;
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) calendarView:(RDVCalendarView *)calendarView didSelectDate:(NSDate *)date
{
    ///self.selctedDate=[dateFormatter stringFromDate:_calendarView.selectedDate];
    
    NSDate *today = [NSDate date];
    NSString *todayDate=[dateFormatter stringFromDate:today];
    
    NSComparisonResult compareResult = [todayDate compare:self.selctedDate];
    
    
    if (compareResult == NSOrderedAscending)
    {
        isSelectedData=YES;
    }
    else if (compareResult == NSOrderedDescending)
    {
        isSelectedData=NO;
        
    }
    else
        isSelectedData=YES;
    
    //self.doneButton.enabled = YES;
}

- (void)calendarView:(RDVCalendarView *)calendarView didSelectCellAtIndex:(NSInteger)index
{
 
    self.selctedDate=[dateFormatter stringFromDate:_calendarView.selectedDate];
    [self calendarView:self.calendarView didSelectDate:nil];
    self.doneButton.enabled = YES;
}

- (IBAction)doneisPressed:(UIBarButtonItem *)sender
{
    NSLog(@"Done is Pressed");
    if (isSelectedData==YES)
    {
        [[self delegate]setDeadline:self.selctedDate];
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    else
    {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                          message:@"The selected date is invaid"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        self.doneButton.enabled = NO;
    }
    
}

@end
