//
//  GFWhatsUpNotifier.h
//  Geofancy
//
//  Created by Marcus Kida on 14.02.14.
//  Copyright (c) 2014 Marcus Kida. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GFWhatsUpNotifier : NSObject

+ (id) sharedNotifier;
- (void) fetchWhatsUpAndNotifyWithCompletion:(void(^)())cb;

@end
