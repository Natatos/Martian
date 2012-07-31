//
//  mainSelectionController.h
//  Martian
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostSelectionController.h"

@interface MainSelectionController : NSObject <NSOutlineViewDelegate, NSOutlineViewDataSource>
{
@private
    NSTableCellView * rowToRemove;
}

@property (assign) IBOutlet NSOutlineView * mainSelectionOutline;
@property (assign) IBOutlet PostSelectionController * postSelectionController;

@property (strong) NSMutableDictionary * data;

- (NSTableCellView*)rowForIndex:(NSInteger)index;

- (void)textDidEndEditing:(NSNotification *)notification;

- (NSMenu*)defaultMenuForRow:(NSString*)stringRow;
- (void)addSubreddit:(id)sender;
- (void)removeSubreddit:(id)sender;

@end