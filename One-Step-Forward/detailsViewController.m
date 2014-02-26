//
//  detailsViewController.m
//  One-Step-Forward
//
//  Created by KHALID ALAHMARI on 2/21/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "detailsViewController.h"

@interface detailsViewController ()

@end

@implementation detailsViewController


@synthesize currentGoalID;
@synthesize postArray;
@synthesize currentGoalProgressPercentage;
@synthesize tableView;
@synthesize doneProgress;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(id) initWithCoder:(NSCoder *)aDecoder
{
    
    self=[super initWithCoder:aDecoder];
    if (self)
    {
    
    }
    
    return self;
}




-(void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
    [self getDoneProgress:nil];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [doneProgress count];
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
//    PFQuery *postQuery = [PFQuery queryWithClassName:@"Progress"];
//    
//    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
//    [postQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//        
//        if (!error) {
//            
//            
//           //self.label.text=[object objectForKey:@"ProgressName"];
//            
//        }
//    }];
    
    NSLog(@"%f",currentGoalProgressPercentage);
    
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) declareAchieved:(UIButton *)sender
{
    
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
    
    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
    
    [postQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        
        if (!error) {

                [object setObject:@YES forKey:@"isGoalCompleted"];
                [object setObject:@NO forKey:@"isGoalinPregress"];
                [object setObject:@"100" forKey:@"goalPercentage"];
                [object saveInBackground];
        }
    }];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Congrats!"
                                                      message:@"You did Achive your goal"
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    
    [message show];
    
}



- (IBAction)addProgress:(UIButton *)sender {
    
    
    PFObject *newProgress = [PFObject objectWithClassName:@"Progress"];
    
    int m=[self checkTheEnteredProgress];
    
    if(m==1)
    {
    
    [newProgress setObject:self.progressTextField.text forKey:@"ProgressName"];
        [newProgress setObject:self.progressPercentage.text forKey:@"ProgressPercentage"];
    
    //Realationship
    [newProgress setObject:currentGoalID forKey:@"goalID"];
    
    NSLog(@"Less Than 100");
        
        
    NSError *error;
        
        [newProgress save:&error];
        
        {
        if (!error) {
            
            [self updateGoal:[self.progressPercentage.text doubleValue]];

        }}
        
        NSLog(@"Less Than 5");

        
        
    }
    
    else if (m==0)
    {
        
        [self declareAchieved:sender];
        
    }
    
    else
    {
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Errot!"
                                                          message:[NSString stringWithFormat:@"The current progress for the selected goal is %.2f",currentGoalProgressPercentage]
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        
        [message show];
        
        

    }
}

-(int) checkTheEnteredProgress
{
    BOOL X=-1;
    
    if (currentGoalProgressPercentage+[self.progressPercentage.text doubleValue] < 100) {
        
        X=1;
    }
    else if (currentGoalProgressPercentage+[self.progressPercentage.text doubleValue] == 100)

    {
        X=0;
    }
    
    return X;
    
}

-(void) updateGoal :(double) progressPercentge
{
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Goal"];
    
    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
    NSError *error;
    
    PFObject *object=[postQuery getFirstObject:&error ];
    
        if (!error) {
            
            NSLog(@"RRR");
            NSString *sum=[NSString stringWithFormat:@"%.2f",progressPercentge+currentGoalProgressPercentage];
            
            NSLog(@"rr%@",sum);
            [object setObject:sum forKey:@"goalPercentage"];
            
            [object save];

        }
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell2";
    progressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *progress = [doneProgress objectAtIndex:indexPath.row];
    [cell.progressName setText: [progress objectForKey:@"ProgressName"]];
    [cell.progressPercentage setText: [progress objectForKey:@"ProgressPercentage"]];
    
    return cell;
}


- (void)getDoneProgress:(id)sender {
    // Create a query
    PFQuery *postQuery = [PFQuery queryWithClassName:@"Progress"];
    postQuery.cachePolicy = kPFCachePolicyCacheThenNetwork;
    
    // Follow relationship
    [postQuery whereKey:@"goalID" equalTo:currentGoalID];
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            doneProgress = objects;           // Store results
            [self.tableView reloadData];   // Reload table
        }
    }];
    
}


@end
