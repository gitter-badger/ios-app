//
//  GFAddEditGeofencesViewControllerTests.m
//  Geofancy
//
//  Created by Marcus Kida on 12.04.14.
//  Copyright (c) 2014 Marcus Kida. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GFAddEditGeofenceViewController.h"

SpecBegin(GFAddEditGeofenceViewControllerTestsSpec)

__block GFAddEditGeofenceViewController *sut = nil;

beforeEach(^{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:[GFAddEditGeofenceViewController class]]];
    sut = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([GFAddEditGeofenceViewController class])];
});

afterEach(^{
    sut = nil;
});

describe(@"the viewcontroller for adding / editing geofences", ^{
    it(@"should be instance of correct class", ^{
        expect(sut).to.beInstanceOf(GFAddEditGeofenceViewController.class);
    });
    
    it(@"should have a data source", ^{
        expect(sut.tableView.dataSource).toNot.beNil;
    });
    
    it(@"should have a delegate", ^{
        expect(sut.tableView.delegate).toNot.beNil;
    });
});

SpecEnd
