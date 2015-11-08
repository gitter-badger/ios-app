//
//  GFWhatsUpNotifier.m
//  Geofancy
//
//  Created by Marcus Kida on 14.02.14.
//  Copyright (c) 2014 Marcus Kida. All rights reserved.
//

#import "GFWhatsUpNotifier.h"
#import "GFConfig.h"

#define WhatsUpUri  @"https://my.geofancy.com/api/whatsup"
#define LastWhatsUpTimestamp @"lastWhatsUpTimestamp"

@implementation GFWhatsUpNotifier

#pragma mark - AFNetworking Security Policy
- (AFSecurityPolicy *) commonPolicy
{
    AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    [policy setAllowInvalidCertificates:YES];
    return policy;
}

+ (id) sharedNotifier
{
    static GFWhatsUpNotifier *notifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notifier = [[GFWhatsUpNotifier alloc] init];
    });
    return notifier;
}

- (void) fetchWhatsUpAndNotifyWithCompletion:(void(^)())cb
{
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate timeIntervalSince1970] < ([[[GFConfig sharedConfig] lastMessageFetch] timeIntervalSince1970] + 86400)) {
        return cb();
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitHour fromDate:currentDate];
    NSUInteger currentHour = [components hour];
    
    if (currentHour < 8 || currentHour > 20) {
        return cb();
    }
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [requestManager setSecurityPolicy:[self commonPolicy]];
    
    [requestManager GET:WhatsUpUri parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&error];
        
        if (!error) {
            if ([[json objectForKey:@"timestamp"] integerValue] > [self lastWhatsUpTimestamp]) {
                NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
                NSString *message = [[json objectForKey:@"messages"] objectForKey:language];
                if (!message) {
                    message = [[json objectForKey:@"messages"] objectForKey:@"en"];
                }
                
                // Show local notification
                UILocalNotification *notification = [UILocalNotification new];
                notification.soundName = @"whatsup.caf";
                notification.alertBody = message;
                [[UIApplication sharedApplication] scheduleLocalNotification:notification];
                
                // And set last timestmap
                [self setLastWhatsUpTimestamp:[[json objectForKey:@"timestamp"] integerValue]];
            }
            
            [[GFConfig sharedConfig] setLastMessageFetch:[NSDate date]];
        }
        
        cb();
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing on failure
        cb();
    }];
}

- (NSInteger) lastWhatsUpTimestamp
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:LastWhatsUpTimestamp];
}

- (void) setLastWhatsUpTimestamp:(NSInteger)timestamp
{
    [[NSUserDefaults standardUserDefaults] setInteger:timestamp forKey:LastWhatsUpTimestamp];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
