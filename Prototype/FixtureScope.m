//
//  FixtureScope.m
//  Fixtures
//
//  Created by Kane Ho on 3/21/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

#import "Fixtures.h"
#import "FixtureScope.h"

#pragma mark - FixtureScope

@interface FixtureScope ()

#pragma mark - Public

@property (nonatomic) NSMutableDictionary *keyValues;
@property (nonatomic) NSMutableArray *fixtures;

@end

@implementation FixtureScope

#pragma mark - Public

- (instancetype)init {
  if (self = [super init]) {
    self.keyValues = [NSMutableDictionary new];
    self.fixtures = [NSMutableArray new];
  }
  return self;
}

@end