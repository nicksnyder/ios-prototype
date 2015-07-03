//
//  FixtureProtocol.m
//  Fixtures
//
//  Created by Andy Clark on 3/16/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

#import "Fixtures.h"
#import "FixtureProtocolEntry.h"
#import "FixtureScope.h"

#pragma mark - FixtureProtocol

@implementation FixtureProtocol

#pragma mark - Public

// code

+ (void)addCode:(NSInteger)code forPath:(NSString*)path method:(NSString*)method {
  [self addCode:code headers:nil forPath:path host:nil method:method];
}

+ (void)addCode:(NSInteger)code headers:(NSDictionary*)headers forPath:(NSString*)path host:(NSString*)host method:(NSString*)method {
  [self.currentScope.fixtures addObject:[[FixtureProtocolEntry alloc] initWithPath:path host:host method:method code:code headers:headers data:nil isTemplate:false]];
}

// raw data

+ (void)addData:(NSData*)data forPath:(NSString*)path method:(NSString*)method {
  [self addData:data code:200 headers:nil forPath:path host:nil method:method isTemplate:false];
}

+ (void)addData:(NSData*)data code:(NSInteger)code headers:(NSDictionary*)headers forPath:(NSString*)path host:(NSString*)host method:(NSString*)method isTemplate:(BOOL)isTemplate {
  [self.currentScope.fixtures addObject:[[FixtureProtocolEntry alloc] initWithPath:path host:host method:method code:code headers:headers data:data isTemplate:false]];
}

// string data

+ (void)addDataFromString:(NSString *)string encoding:(NSStringEncoding)encoding forPath:(NSString *)path method:(NSString *)method {
  [self addDataFromString:string encoding:encoding code:200 headers:nil forPath:path host:nil method:method];
}

+ (void)addDataFromString:(NSString *)string encoding:(NSStringEncoding)encoding code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  NSData *data = [string dataUsingEncoding:encoding allowLossyConversion:NO];
  [self addData:data code:code headers:headers forPath:path host:host method:method isTemplate:false];
}

// json data

+ (void)addDataFromJson:(NSDictionary *)json forPath:(NSString *)path method:(NSString *)method {
  [self addDataFromJson:json code:200 headers:nil forPath:path host:nil method:method];
}

+ (void)addDataFromJson:(NSDictionary *)json code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:NULL];
  [self addData:data code:code headers:headers forPath:path host:host method:method isTemplate:false];
}

// file data

+ (void)addDataFromFile:(NSString *)file forPath:(NSString *)path method:(NSString *)method {
  [self addDataFromFile:file code:200 headers:nil forPath:path host:nil method:method];
}

+ (void)addDataFromFile:(NSString *)file code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  [self.currentScope.fixtures addObject:[[FixtureProtocolEntry alloc] initWithPath:path host:host method:method code:code headers:headers dataFile:file isTemplate:false]];
}

// resource data

+ (void)addDataFromResourceNamed:(NSString *)name bundle:(NSBundle *)bundle forPath:(NSString *)path method:(NSString *)method {
  [self addDataFromResourceNamed:name bundle:bundle code:200 headers:nil forPath:path host:nil method:method];
}

+ (void)addDataFromResourceNamed:(NSString *)name bundle:(NSBundle *)bundle code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  [self.currentScope.fixtures addObject:[[FixtureProtocolEntry alloc] initWithPath:path host:host method:method code:code headers:headers dataResourceName:name bundle:bundle isTemplate:false]];
}

// url data

+ (void)addDataFromURL:(NSURL *)URL forPath:(NSString *)path method:(NSString *)method {
  [self addDataFromURL:URL code:200 headers:nil forPath:path host:nil method:method];
}

+ (void)addDataFromURL:(NSURL *)URL code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  [self.currentScope.fixtures addObject:[[FixtureProtocolEntry alloc] initWithPath:path host:host method:method code:code headers:headers dataUrl:URL isTemplate:false]];
}

// block data

+ (void)addDataFromBlock:(FixtureProtocolBlock)block forPath:(NSString *)path method:(NSString *)method {
  [self addDataFromBlock:block code:200 headers:nil forPath:path host:nil method:method];
}

+ (void)addDataFromBlock:(FixtureProtocolBlock)block code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  [self.currentScope.fixtures addObject:[[FixtureProtocolEntry alloc] initWithPath:path host:host method:method code:code headers:headers dataBlock:block]];
}

// string template

+ (void)addTemplateFromString:(NSString *)string encoding:(NSStringEncoding)encoding forPath:(NSString *)path method:(NSString *)method {
  [self addTemplateFromString:string encoding:encoding code:200 headers:nil forPath:path host:nil method:method];
}

+ (void)addTemplateFromString:(NSString *)string encoding:(NSStringEncoding)encoding code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  NSData *data = [string dataUsingEncoding:encoding allowLossyConversion:NO];
  [self addData:data code:code headers:headers forPath:path host:host method:method isTemplate:true];
}

// json template

+ (void)addTemplateFromJson:(NSDictionary *)json forPath:(NSString *)path method:(NSString *)method {
  [self addTemplateFromJson:json code:200 headers:nil forPath:path host:nil method:method];
}

+ (void)addTemplateFromJson:(NSDictionary *)json code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  NSData *data = [NSJSONSerialization dataWithJSONObject:json options:0 error:NULL];
  [self addData:data code:code headers:headers forPath:path host:host method:method isTemplate:true];
}

// file template

+ (void)addTemplateFromFile:(NSString *)file forPath:(NSString *)path method:(NSString *)method {
  [self addTemplateFromFile:file code:200 headers:nil forPath:path host:nil method:method];
}

+ (void)addTemplateFromFile:(NSString *)file code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  [self.currentScope.fixtures addObject:[[FixtureProtocolEntry alloc] initWithPath:path host:host method:method code:code headers:headers dataFile:file isTemplate:true]];
}

// resource template

+ (void)addTemplateFromResourceNamed:(NSString *)name bundle:(NSBundle *)bundle forPath:(NSString *)path method:(NSString *)method {
  [self addTemplateFromResourceNamed:name bundle:bundle code:200 headers:nil forPath:path host:nil method:method];
}

+ (void)addTemplateFromResourceNamed:(NSString *)name bundle:(NSBundle *)bundle code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  [self.currentScope.fixtures addObject:[[FixtureProtocolEntry alloc] initWithPath:path host:host method:method code:code headers:headers dataResourceName:name bundle:bundle isTemplate:true]];
}

// url template

+ (void)addTemplateFromURL:(NSURL *)URL forPath:(NSString *)path method:(NSString *)method {
  [self addTemplateFromURL:URL code:200 headers:nil forPath:path host:nil method:method];
}

+ (void)addTemplateFromURL:(NSURL *)URL code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  [self.currentScope.fixtures addObject:[[FixtureProtocolEntry alloc] initWithPath:path host:host method:method code:code headers:headers dataUrl:URL isTemplate:true]];
}

// key values for template rendering

+ (void)addKeyValues:(NSDictionary *)keyValues {
  for (id key in keyValues) {
    [self.currentScope.keyValues setObject:[keyValues objectForKey:key] forKey:key];
  }
}

// remove

+ (void)removePath:(NSString *)path method:(NSString *)method {
  [self removePath:path host:nil method:method];
}

+ (void)removePath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  NSUInteger count = self.currentScope.fixtures.count;
  for (NSUInteger i = 0; i < count; i++) {
    FixtureProtocolEntry *entry = self.currentScope.fixtures[i];
    BOOL pathMatches = [entry.requestPath isEqualToString:path];
    BOOL hostMatches = entry.requestHost == nil || [entry.requestHost isEqualToString:host];
    BOOL methodMatches = entry.requestMethod == nil || [entry.requestMethod isEqualToString:method];
    if (pathMatches && hostMatches && methodMatches) {
      [self.currentScope.fixtures removeObjectAtIndex:i];
      break;
    }
  }
}

+ (void)removeAll {
  [self.currentScope.fixtures removeAllObjects];
}

#pragma mark - Public (Fixture Scope)

+ (void)enterScope {
  [self.scopes addObject:[FixtureScope new]];
}

+ (void)exitScope {
  if (self.scopes.count > 1) {
    [self.scopes removeLastObject];
  }
}

#pragma mark - NSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
  NSURL *URL = request.URL;
  NSString *path = URL.path;
  NSString *host = URL.host;
  NSString *method = request.HTTPMethod;

  return path != nil && host != nil && method != nil &&
         [self entryForPath:path host:host method:method] != nil;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
  return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
  return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading {
  NSURL *URL = self.request.URL;
  NSString *path = URL.path;
  NSString *host = URL.host;
  NSString *method = self.request.HTTPMethod;
  NSLog(@"Fixture: %@ %@", method ?: @"URL", URL);

  // check values
  if (path == nil) {
    [self handleErrorMessage:@"Request URL path missing"];
    return;
  }

  if (host == nil) {
    [self handleErrorMessage:@"Request URL host missing"];
    return;
  }

  if (method == nil) {
    [self handleErrorMessage:@"Request method missing"];
    return;
  }

  // handle fixture
  FixtureProtocolEntry *entry = [FixtureProtocol entryForPath:path host:host method:method];
  if (entry != nil) {
    NSInteger code = entry.responseCode;
    NSLog(@"Fixture: RESPONSE %d", (int)code);

    // did receive response
    if ([self.client respondsToSelector:@selector(URLProtocol:didReceiveResponse:cacheStoragePolicy:)]) {
      NSString *version = @"1.1";
      NSDictionary *headers = entry.responseHeaders;
      NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:URL statusCode:code HTTPVersion:version  headerFields:headers];
      NSURLCacheStoragePolicy policy = NSURLCacheStorageNotAllowed;
      [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:policy];
    }

    // did load data
    NSData *data = [entry dataForRequest:self.request];
    if (data != nil) {
      NSString *dataText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ?: data.description;
      NSString *dataDescription = dataText.length > 0 ? dataText : @"(no data)";
      NSLog(@"Fixture: DATA %@\n%@", entry.responseDataDescription, dataDescription);
      if ([self.client respondsToSelector:@selector(URLProtocol:didLoadData:)]) {
        [self.client URLProtocol:self didLoadData:data];
      }
    }

    // error: no data
    else if (entry.hasResponseData) {
      NSLog(@"Fixture: ERROR - expected DATA %@", entry.responseDataDescription);
    }

    // did finish loading
    if ([self.client respondsToSelector:@selector(URLProtocolDidFinishLoading:)]) {
      [self.client URLProtocolDidFinishLoading:self];
    }
  }
  else {
    [self handleErrorMessage:@"Fixture entry missing"];
  }
}

- (void)stopLoading {
  // no-op
}



#pragma mark - Private

+ (NSMutableArray *)scopes {
  static NSMutableArray *array;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    // NOTE: start with a default scope
    array = [NSMutableArray arrayWithObject:[FixtureScope new]];
  });
  return array;
}

+ (FixtureScope *)currentScope {
  return [[self scopes] lastObject];
}

+ (FixtureProtocolEntry *)entryForPath:(NSString *)path host:(NSString *)host method:(NSString *)method {
  NSEnumerator *scopeEnumerator = [self.scopes reverseObjectEnumerator];
  for (FixtureScope *scope in [scopeEnumerator allObjects]) {
    for (FixtureProtocolEntry *entry in scope.fixtures) {
      if ([entry matchesPath:path host:host method:method]) {
        return entry;
      }
    }
  }
  return nil;
}

+ (NSDictionary *)flattenKeyValues {
  NSMutableDictionary *keyValues = [NSMutableDictionary new];
  for (FixtureScope *scope in self.scopes) {
    for (id key in [scope keyValues]) {
      [keyValues setObject:[[scope keyValues] objectForKey:key] forKey:key];
    }
  }
  return keyValues;
}

- (void)handleErrorMessage:(NSString *)message {
  if ([self.client respondsToSelector:@selector(URLProtocol:didFailWithError:)]) {
    NSDictionary *userInfo = @{
      NSLocalizedDescriptionKey: message ?: @"Fixture startLoading failed"
    };
    NSError *error = [NSError errorWithDomain:@"FixtureProtocol" code:0 userInfo:userInfo];
    [self.client URLProtocol:self didFailWithError:error];
  }
}

@end
