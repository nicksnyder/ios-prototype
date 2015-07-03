//
//  FixtureProtocolEntry.h
//  Fixtures
//
//  Created by Kane Ho on 3/21/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

#import "Fixtures.h"

#pragma mark - FixtureProtocolEntry

@interface FixtureProtocolEntry : NSObject

#pragma mark - Public

@property (nonatomic, readonly) NSString *requestPath;
@property (nonatomic, readonly) NSString *requestHost;
@property (nonatomic, readonly) NSString *requestMethod;

@property (nonatomic, readonly) NSInteger responseCode;
@property (nonatomic, readonly) NSDictionary *responseHeaders;
@property (nonatomic, readonly) NSData *responseData;
@property (nonatomic, readonly) NSString *responseDataFile;
@property (nonatomic, readonly) NSString *responseDataResourceName;
@property (nonatomic, readonly) NSBundle *responseDataResourceBundle;
@property (nonatomic, readonly) NSURL *responseDataUrl;
@property (nonatomic, readonly) FixtureProtocolBlock responseDataBlock;

@property (nonatomic, readonly) BOOL hasResponseData;

@property (nonatomic, readonly) NSString *responseDataDescription;

- (instancetype)initWithPath:(NSString *)path host:(NSString *)host method:(NSString *)method code:(NSInteger)code headers:(NSDictionary *)headers data:(NSData *)data isTemplate:(BOOL)template;

- (instancetype)initWithPath:(NSString *)path host:(NSString *)host method:(NSString *)method code:(NSInteger)code headers:(NSDictionary *)headers dataFile:(NSString *)file isTemplate:(BOOL)template;

- (instancetype)initWithPath:(NSString *)path host:(NSString *)host method:(NSString *)method code:(NSInteger)code headers:(NSDictionary *)headers dataResourceName:(NSString *)name bundle:(NSBundle *)bundle isTemplate:(BOOL)template;

- (instancetype)initWithPath:(NSString *)path host:(NSString *)host method:(NSString *)method code:(NSInteger)code headers:(NSDictionary *)headers dataUrl:(NSURL *)url isTemplate:(BOOL)template;

- (instancetype)initWithPath:(NSString *)path host:(NSString *)host method:(NSString *)method code:(NSInteger)code headers:(NSDictionary *)headers dataBlock:(FixtureProtocolBlock)block;

- (NSData *)dataForRequest:(NSURLRequest *)request;

- (BOOL)matchesPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

@end
