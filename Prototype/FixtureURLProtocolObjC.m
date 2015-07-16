//
//  Created by Nick Snyder on 7/16/15.
//  Copyright © 2015 Example. All rights reserved.
//

#import "FixtureURLProtocolObjC.h"

@implementation FixtureURLProtocolObjC

+ (BOOL)canInitWithRequest:(nonnull NSURLRequest *)request {
  NSLog(@"can init With request");
  return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(nonnull NSURLRequest *)request {
  return request;
}

+ (BOOL)requestIsCacheEquivalent:(nonnull NSURLRequest *)a toRequest:(nonnull NSURLRequest *)b {
  return false;
}

- (void)startLoading {
  NSLog(@"start loading");
}

- (void)stopLoading {
  NSLog(@"stop loading");
}

@end
