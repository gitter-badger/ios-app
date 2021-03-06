//
//  GFGeofencesViewControllerTests.m
//  Geofancy
//
//  Created by Marcus Kida on 12.04.14.
//  Copyright (c) 2014 Marcus Kida. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GFGeofencesViewController.h"

SpecBegin(GFGeofencesViewControllerTestsSpec)

__block GFGeofencesViewController *sut = nil;

beforeEach(^{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle bundleForClass:[GFGeofencesViewController class]]];
    sut = [storyboard instantiateViewControllerWithIdentifier:@"Geofences"];
});

afterEach(^{
    sut = nil;
});

describe(@"GeofenceViewController", ^{
    
    it(@"should be instance of correct clas", ^{
        expect(sut).to.beInstanceOf(GFGeofencesViewController.class);
    });
    
    it(@"should have a data source", ^{
        expect(sut.tableView.dataSource).toNot.beNil;
    });
    
    it(@"should have a delegate", ^{
        expect(sut.tableView.delegate).toNot.beNil;
    });
});

SpecEnd
