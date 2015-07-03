//
//  FixtureProtocolEntry.m
//  Fixtures
//
//  Created by Kane Ho on 3/21/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

#import "Fixtures.h"
#import "FixtureProtocolEntry.h"

#pragma mark - FixtureProtocolEntry

@interface FixtureProtocolEntry ()

#pragma mark - Public

@property (nonatomic) NSString *requestPath;
@property (nonatomic) NSString *requestHost;
@property (nonatomic) NSString *requestMethod;

@property (nonatomic) NSInteger responseCode;
@property (nonatomic) NSDictionary *responseHeaders;
@property (nonatomic) NSData *responseData;
@property (nonatomic) NSString *responseDataFile;
@property (nonatomic) NSString *responseDataResourceName;
@property (nonatomic) NSBundle *responseDataResourceBundle;
@property (nonatomic) NSURL *responseDataUrl;
@property (nonatomic) BOOL responseIsTemplate;
@property (nonatomic, strong) FixtureProtocolBlock responseDataBlock;

@property (nonatomic) BOOL hasResponseData;

@property (nonatomic) NSString *responseDataDescription;

#pragma mark - Private

@property (nonatomic) NSRegularExpression *requestPathRegex;
@property (nonatomic) NSRegularExpression *requestHostRegex;

@end

#pragma mark - FixtureProtocolEntry (Public)

@implementation FixtureProtocolEntry

#pragma mark - Public

- (BOOL)hasResponseData {
  return self.responseData != nil || self.responseDataFile != nil ||
  self.responseDataResourceName != nil || self.responseDataUrl != nil ||
  self.responseDataBlock != nil;
}

- (NSString *)responseDataDescription {
  if (self.responseData != nil) {
    return @"raw data";
  }
  if (self.responseDataFile != nil) {
    return [NSString stringWithFormat:@"file: %@", self.responseDataFile];
  }
  if (self.responseDataResourceName != nil) {
    NSString *description = [NSString stringWithFormat:@"resource: %@", self.responseDataResourceName];
    if (self.responseDataResourceBundle != nil) {
      return [NSString stringWithFormat:@"%@, bundle: %@", description, self.responseDataResourceBundle];
    }
    return description;
  }
  if (self.responseDataUrl != nil) {
    return [NSString stringWithFormat:@"url: %@", self.responseDataUrl];
  }
  if (self.responseDataBlock != nil) {
    return @"block";
  }
  return @"(none)";
}

- (instancetype)initWithPath:(NSString *)path host:(NSString *)host method:(NSString *)method code:(NSInteger)code headers:(NSDictionary *)headers data:(NSData *)data isTemplate:(BOOL)template {
  if (self = [super init]) {
    self.requestPath = path;
    if ([path rangeOfString:@"*"].location != NSNotFound) {
      NSString *pattern = path;
      pattern = [pattern stringByReplacingOccurrencesOfString:@"." withString:@"\\." options:0 range:NSMakeRange(0, pattern.length)];
      pattern = [pattern stringByReplacingOccurrencesOfString:@"*" withString:@".*" options:0 range:NSMakeRange(0, pattern.length)];
      self.requestPathRegex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    }
    
    self.requestHost = host;
    if (host != nil && [host rangeOfString:@"*"].location != NSNotFound) {
      NSString *pattern = host;
      pattern = [pattern stringByReplacingOccurrencesOfString:@"." withString:@"\\." options:0 range:NSMakeRange(0, pattern.length)];
      pattern = [pattern stringByReplacingOccurrencesOfString:@"*" withString:@".*" options:0 range:NSMakeRange(0, pattern.length)];
      self.requestHostRegex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:NULL];
    }
    
    self.requestMethod = method;
    self.responseCode = code;
    self.responseHeaders = headers;
    self.responseData = data;
    self.responseIsTemplate = template;
  }
  return self;
}

- (instancetype)initWithPath:(NSString *)path host:(NSString *)host method:(NSString *)method code:(NSInteger)code headers:(NSDictionary *)headers dataFile:(NSString *)file isTemplate:(BOOL)template {
  if (self = [self initWithPath:path host:host method:method code:code headers:headers data:nil isTemplate:template]) {
    self.responseDataFile = file;
  }
  return self;
}

- (instancetype)initWithPath:(NSString *)path host:(NSString *)host method:(NSString *)method code:(NSInteger)code headers:(NSDictionary *)headers dataResourceName:(NSString *)name bundle:(NSBundle *)bundle isTemplate:(BOOL)template {
  if (self = [self initWithPath:path host:host method:method code:code headers:headers data:nil isTemplate:template]) {
    self.responseDataResourceName = name;
    self.responseDataResourceBundle = bundle;
  }
  return self;
}

- (instancetype)initWithPath:(NSString *)path host:(NSString *)host method:(NSString *)method code:(NSInteger)code headers:(NSDictionary *)headers dataUrl:(NSURL *)url isTemplate:(BOOL)template{
  if (self = [self initWithPath:path host:host method:method code:code headers:headers data:nil isTemplate:template]) {
    self.responseDataUrl = url;
  }
  return self;
}

- (instancetype)initWithPath:(NSString *)path host:(NSString *)host method:(NSString *)method code:(NSInteger)code headers:(NSDictionary *)headers dataBlock:(FixtureProtocolBlock)block {
  if (self = [self initWithPath:path host:host method:method code:code headers:headers data:nil isTemplate:false]) {
    self.requestPath = path;
    self.responseDataBlock = block;
  }
  return self;
}

- (NSData *)dataForRequest:(NSURLRequest *)request {
  if (self.responseData != nil) {
    return self.responseData;
  }
  if (self.responseDataFile != nil) {
    return [NSData dataWithContentsOfFile:self.responseDataFile];
  }
  if (self.responseDataResourceName != nil) {
    NSBundle *bundle = self.responseDataResourceBundle ?: [NSBundle mainBundle];
    NSString *dataResourcePath = [bundle pathForResource:self.responseDataResourceName ofType:nil];
    if (dataResourcePath != nil) {
      return [NSData dataWithContentsOfFile:dataResourcePath];
    }
  }
  if (self.responseDataUrl != nil) {
    return [NSData dataWithContentsOfURL:self.responseDataUrl];
  }
  if (self.responseDataBlock != nil) {
    return self.responseDataBlock(request);
  }
  return nil;
}

- (BOOL)matchesPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  BOOL matchesPath;
  if (self.requestPathRegex != nil) {
    NSRange range = NSMakeRange(0, path.length);
    NSArray *matches = [self.requestPathRegex matchesInString:path options:NSMatchingAnchored range:range];
    matchesPath = matches.count > 0;
  }
  else {
    matchesPath = [path isEqualToString:self.requestPath];
  }
  
  BOOL matchesHost;
  if (self.requestHostRegex != nil) {
    NSRange range = NSMakeRange(0, host.length);
    NSArray *matches = [self.requestHostRegex matchesInString:host options:NSMatchingAnchored range:range];
    matchesHost = matches.count > 0;
  }
  else {
    matchesHost = self.requestHost == nil || [self.requestHost isEqualToString:host];
  }
  
  BOOL matchesMethod = self.requestMethod == nil || [self.requestMethod isEqualToString:method];
  
  return matchesPath && matchesHost && matchesMethod;
}

@end