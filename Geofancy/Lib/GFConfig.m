//
//  GFConfig.m
//  Geofancy
//
//  Created by Marcus Kida on 14.02.14.
//  Copyright (c) 2014 Marcus Kida. All rights reserved.
//

#import "GFConfig.h"

#define kBackgroundFetchMessageShown @"backgroundFetchMessageShown"
#define kLastMessageFetch @"lastMessageFetch"

@implementation GFConfig

+ (id) sharedConfig
{
    static GFConfig *config = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        config = [[GFConfig alloc] init];
    });
    return config;
}

- (BOOL) backgroundFetchMessageShown
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kBackgroundFetchMessageShown];
}

- (void) setBackgroundFetchMessageShown:(BOOL)backgroundFetchMessageShown
{
    [[NSUserDefaults standardUserDefaults] setBool:backgroundFetchMessageShown forKey:kBackgroundFetchMessageShown];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *) lastMessageFetch
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kLastMessageFetch];
}

- (void) setLastMessageFetch:(NSDate *)lastMessageFetch
{
    [[NSUserDefaults standardUserDefaults] setObject:lastMessageFetch forKey:kLastMessageFetch];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
