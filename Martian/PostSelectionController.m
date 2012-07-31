//
//  PostSelectionController.m
//  Martian
//
//  Created by evan schoffstall on 7/30/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "PostSelectionController.h"

@implementation PostSelectionController
@synthesize data, postSelectionTable, requests, requestTimer;


- (id)init
{
    if (self == [super self])
    {
        requestTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(resetRequests:) userInfo:nil repeats:YES];
        [requestTimer fire];
    }
    return self;
}

- (NSView*)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    NSTableCellView * aView = [postSelectionTable makeViewWithIdentifier:[tableColumn identifier] owner:self];
    
    [(NSTextField*)[self viewForIdentifier:@"userField" ofSuperview:aView] setStringValue:[[[data objectAtIndex:row] objectForKey:@"data"] objectForKey:@"author"]];
    [(NSTextField*)[self viewForIdentifier:@"postField" ofSuperview:aView] setStringValue:[[[data objectAtIndex:row] objectForKey:@"data"] objectForKey:@"title"]];
    return aView;
    
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
    return [data count];
}

- (NSView*)viewForIdentifier:(NSString*)identifier ofSuperview:(NSView*)superview
{
    for (NSView * subview in [superview subviews])
    {
        if ([[subview identifier] isEqualToString:identifier])
            return subview;
    }
    
    return nil;
}

- (void)updatePostDataForString:(NSString*)string
{
    NSArray * possibleData = [[[self dictionaryFromRequest:string] objectForKey:@"data"]  objectForKey:@"children"];
    
    if (possibleData)
        data = (NSMutableArray*)possibleData;
}

- (void)willDisplayViewForItem:(NSString*)item
{
    if ([item isEqualToString:@"Front page"])
    {
        [self updatePostDataForString:@"http://api.reddit.com/"];
        [postSelectionTable reloadData];
    }
}

- (void)resetRequests:(NSTimer*)timer
{
    requests = 0;
}

- (NSMutableDictionary*)dictionaryFromRequest:(NSString*)requestString
{
    if (requests >= 1)
    {
        NSLog(@"Sorry, but you need to keep requests down to one per two seconds");
        return nil;
    }
        
    SBJsonParser *parser = [SBJsonParser new];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    
    [request setValue:@"(JSON) Martian Reddit Client by anleaves" forHTTPHeaderField:@"User-Agent"];
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *json_string = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
    
    ++requests;
    
    return [parser objectWithString:json_string error:nil];
}


@end
