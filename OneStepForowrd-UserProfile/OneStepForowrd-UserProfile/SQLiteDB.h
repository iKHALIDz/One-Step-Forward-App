//
//  SQLiteDB.h
//  MassTransitApp
//
//  Created by KHALID ALAHMARI on 11/8/13.
//  Copyright (c) 2013 Khalid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface SQLiteDB : NSObject
{
	sqlite3* _databaseConnection;
	NSString* _dbpath;
}


@property (nonatomic,retain) NSString *dbpath;


+(SQLiteDB *) databaseWithPath: (NSString*) Path;

-(id) initWithPath: (NSString*) Path;

- (void)dealloc;


-(sqlite3 *) getConnection;


@end
