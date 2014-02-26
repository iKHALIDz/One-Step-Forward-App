//
//  MainViewController.m
//  LoginT
//
//  Created by KHALID ALAHMARI on 2/25/14.
//  Copyright (c) 2014 Khalid. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"

@interface MainViewController ()

@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@property (nonatomic,strong) NSFetchedResultsController *fetchResultsController;


@end

@implementation MainViewController

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
	// Do any additional setup after loading the view.
    
    NSError *error;
    
    if (![[self fetchResultsController]performFetch:&error]) {
        
        NSLog(@"Error! %@",error);
        abort();
        
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(NSManagedObjectContext *) managedObjectContext {
    
    
    return [(AppDelegate*)[UIApplication sharedApplication]managedObjectContext];
    
}

-(NSFetchedResultsController*) fetchResultsController{
    
    if (_fetchResultsController !=nil) {
        return _fetchResultsController;
    }
    
    NSFetchRequest *feechRequest=[[NSFetchRequest alloc]init];
    
    NSManagedObjectContext * context = [self managedObjectContext];
    
    NSEntityDescription *entity =[NSEntityDescription entityForName:@"User" inManagedObjectContext:context];
    
    [feechRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc]initWithKey:@
                                      "username" ascending:YES];
    NSArray *sortDescriptors= [[NSArray alloc]initWithObjects:sortDescriptor, nil];
    
    feechRequest.sortDescriptors=sortDescriptors;
    
    _fetchResultsController= [[NSFetchedResultsController alloc]initWithFetchRequest:feechRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    _fetchResultsController.delegate=self;
    
    return _fetchResultsController;
    
}

- (IBAction)press:(id)sender {
    
    
    User *u=[[self fetchResultsController]objectAtIndexPath:0];
    
    
    self.userLabel.text=u.username;
    
}
@end
