//
//  SQLiteDB.m
//  MassTransitApp
//
//  Created by KHALID ALAHMARI on 11/8/13.
//  Copyright (c) 2013 Khalid. All rights reserved.
//

#import "SQLiteDB.h"

@implementation SQLiteDB


static SQLiteDB *_databaseObj;

@synthesize dbpath=_dbpath;


-(id) initWithPath: (NSString*) Path
{
    self = [super init];
    
    if (self)
    {
        
        
        NSArray *strings = [Path componentsSeparatedByString:@"."];
        NSString *path = [[NSBundle mainBundle] pathForResource:[strings objectAtIndex:0]
                                                        ofType:[strings objectAtIndex:1]];
        
        
        NSLog(@"path: %@",path);
        
        if (sqlite3_open([path UTF8String], &_databaseConnection) != SQLITE_OK)
        {
            
            NSLog(@"[SQLITE] Unable to open database!");
            //return nil; // if it fails, return nil obj
        }
        else
        {
            
            NSLog(@"[SQLITE] open database!");

        }
    }
    return self;
}


+(SQLiteDB *) databaseWithPath: (NSString*) Path
{
    if (_databaseObj == nil)
    {
        _databaseObj = [[SQLiteDB alloc] initWithPath:Path];
        
    }
    return _databaseObj;
}

- (void)dealloc
{
    sqlite3_close(_databaseConnection);
}



-(sqlite3 *) getConnection
{
    return _databaseConnection;
}




@end
