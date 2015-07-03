//
//  FixtureScope.h
//  Fixtures
//
//  Created by Kane Ho on 3/21/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

#import "Fixtures.h"

#pragma mark - FixtureScope

@interface FixtureScope : NSObject

#pragma mark - Public

@property (nonatomic, readonly) NSMutableDictionary *keyValues;
@property (nonatomic, readonly) NSMutableArray *fixtures;

- (instancetype) init;

@end
