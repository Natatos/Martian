//
//  outlineDelegate.m
//  Alien Blue
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "OutlineDelegate.h"

@implementation OutlineDelegate
@synthesize data, aOutlineView, subscriptions;

- (id)init
{
    if (self == [super self])
    {
        subscriptions = [NSMutableArray arrayWithObjects:@"Technology",@"Science",@"Apple",nil];
        data = [NSMutableArray new];
        
        [data addObject:@"Front page"];
        [data addObject:@"Messages"];
        [data addObject:[NSDictionary dictionaryWithObject:subscriptions forKey:@"Subscriptions"]];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidEndEditing:) name:@"NSControlTextDidEndEditingNotification" object:nil];
    }
    
    return self;
}

- (NSView*)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    NSTableCellView * aView = [outlineView makeViewWithIdentifier:[tableColumn identifier] owner:self];
    
    if ([item isKindOfClass:[NSDictionary class]])
        item = [[item allKeys] objectAtIndex:0];
    
    if (item == @"")
        [[aView textField] setSelectable:NO]; // Broken; need a way to set the selectablity of the cell, not just the textField.
        
    [[aView textField] setStringValue:item];
    return aView;
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    if (item == nil)
    {
        return [data count];
    }
    else if ([item isKindOfClass:[NSDictionary class]])
    {
        return [[item objectForKey:[[item allKeys] objectAtIndex:0]] count];
    }
    
    return 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
    if ([self outlineView:outlineView numberOfChildrenOfItem:item] > 0)
    {
        return YES;
    }
    
    return NO;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldEditTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    return YES;
}

- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    if (item == nil)
    {
        return [data objectAtIndex:index];
    }
    else if ([item isKindOfClass:[NSDictionary class]])
    {
        return [[item objectForKey:[[item allKeys] objectAtIndex:0]] objectAtIndex:index];
    }
    
    return nil;
}

- (NSMenu*)defaultMenuForRow:(NSString*)stringRow
{
    int row = [stringRow intValue];
    
    if (row < 0) return nil;
    
    NSTableCellView * aRow = [self rowForIndex:row];
    
    NSMenu *theMenu = [NSMenu new];
    
    if ([[[aRow textField] stringValue] isEqualToString:@"Subscriptions"])
    {
        [self selectRow:row];
        
        [theMenu insertItemWithTitle:@"Add" action:@selector(addSubreddit:) keyEquivalent:@"" atIndex:0];
        
        return theMenu;
    }
    else if ([subscriptions containsObject:[[aRow textField] stringValue]])
    {
        [self selectRow:row];
        
        [theMenu insertItemWithTitle:@"Remove" action:@selector(removeSubreddit:) keyEquivalent:@"" atIndex:0];
        
        rowToRemove = aRow;
    }
    
    return theMenu;
}

- (NSTableCellView*)rowForIndex:(NSInteger)index
{
    return [[[[aOutlineView outlineTableColumn] tableView] rowViewAtRow:index makeIfNecessary:YES] viewAtColumn:0];
}

- (void)selectRow:(NSInteger)row
{
    [aOutlineView selectRowIndexes:[NSIndexSet indexSetWithIndex:row] byExtendingSelection:NO];
}

- (void)editRow:(NSInteger)row
{
    [aOutlineView editColumn:0 row:row withEvent:[NSApp currentEvent] select:YES];
}

- (void)removeSubreddit:(id)sender
{
    [[self subscriptions] removeObject:[[rowToRemove textField] stringValue]];
    [aOutlineView reloadData];
}

- (void)addSubreddit:(id)sender
{
    NSInteger row = [subscriptions count]+[data count];
    
    [subscriptions addObject:@"untitled"];
    [aOutlineView reloadData];
    [[[self rowForIndex:row] textField] setEditable:YES];
    [aOutlineView reloadData];
    [self selectRow:row];
    [self editRow:row];
}

- (void)textDidEndEditing:(NSNotification *)notification
{
    NSInteger row = [subscriptions count]+[data count]-1;
    [[[self rowForIndex:row] textField] setEditable:NO];
    [aOutlineView reloadData];
    [self selectRow:row];
}

@end
