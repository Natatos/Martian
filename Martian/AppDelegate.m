//
//  AppDelegate.m
//  Alien Blue
//
//  Created by evan schoffstall on 7/28/12.
//  Copyright (c) 2012 evan schoffstall. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate
@synthesize outlineDelegate;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    // Okay, so I hate doing operations up on termination, but this will be a temporary thing.
    
    NSMutableDictionary * data = [AppDelegate dataPlist];
    
    if ([[data objectForKey:@"firstLaunch"] isEqualTo:@"YES"])
        [data setObject:@"NO" forKey:@"firstLaunch"];
        
    if ([outlineDelegate data])
        [data setObject:[outlineDelegate data] forKey:@"outlineData"];
    
    NSMutableArray * expandedItems = [NSMutableArray new];
    
    for (id item in [outlineDelegate data])
    {
        if ([item isKindOfClass:[NSDictionary class]] && [[outlineDelegate aOutlineView] isItemExpanded:item])
            [expandedItems addObject:[[item allKeys] objectAtIndex:0]];
    }
    
    [data setObject:expandedItems forKey:@"expandedItems"];
    
    [data writeToFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Data.plist"] atomically:YES];
}

+ (NSMutableDictionary*)dataPlist
{
    return [NSMutableDictionary dictionaryWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"Data.plist"]];
}

@end
