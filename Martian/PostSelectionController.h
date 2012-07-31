//
//  PostSelectionController.h
//  Martian
//
//  Created by evan schoffstall on 7/30/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJason/SBJson.h"

@interface PostSelectionController : NSObject <NSTableViewDataSource, NSTableViewDelegate>

@property (assign) IBOutlet NSTableView * postSelectionTable;
@property (strong) NSMutableArray * data;

@property (assign) NSInteger requests;
@property (strong) NSTimer * requestTimer;

- (void)willDisplayViewForItem:(NSString*)item;

@end
