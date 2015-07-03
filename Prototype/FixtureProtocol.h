//
//  FixtureProtocol.h
//  Fixtures
//
//  Created by Andy Clark on 3/16/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

#import "Fixtures.h"

#pragma mark - FixtureProtocol

/*!
 This class provides a convenient way to intercept any application URL request
 and return a custom fixture response. The fixture can return a specific response
 code, headers, and data. In the case of custom response data, the data can be
 from a NSData object, a resource bundle, a URL, or even from a custom block.

 Fixtures are added by using one of the convenient add methods following the 
 pattern addXyz:forPath:. For example, [FixtureProtocol addCode:500 forPath:@"/foo"]
 would intercept all requests whose path is exactly "/foo" and return a 500
 response code.

 Fixture paths may contain wildcards to all allow matching of multiple requests
 that share common paths. For example, [FixtureProtocol addCode:401 forPath:@"/foo*"]
 would intercept all requests that start with "/foo" and return a 401 response code.

 Requests are checked against fixture paths in the order that the fixtures were
 added. The first matching fixture is used; no other paths are considered.

 Fixtures may also be added to separate scopes. The FixtureProtocol starts
 with a default scope but new scopes can be used by calling enterScope and
 exitScope. Scopes can be considered a stack of lists of fixtures.

 Requests are compared against all paths in all scopes until a match is found.
 The paths are checked from the most recently added scope all the way back to
 the default scope. If no match is found, no fixture is applied and the request
 proceeds normally.
 */
@interface FixtureProtocol : NSURLProtocol

#pragma mark - Public

/*!
 Add a fixture with a specific response code but no data.

 \param code     Response code.
 \param forPath  Request path. May contain "*" wildcards.
 \param method   Request method. If nil, matches all methods.
 */
+ (void)addCode:(NSInteger)code forPath:(NSString*)path method:(NSString*)method;

/*!
 Add a fixture with a specific response code but no data.

 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addCode:(NSInteger)code headers:(NSDictionary*)headers forPath:(NSString*)path host:(NSString*)host method:(NSString*)method;

/*!
 Add a fixture with response data.

 \param data     Response data.
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addData:(NSData*)data forPath:(NSString*)path method:(NSString*)method;

/*!
 Add a fixture with response data.

 \param data       Response data.
 \param code       Response code.
 \param headers    (Optional) Response headers.
 \param forPath    Request path. May contain "*" wildcards.
 \param host       (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method     (Optional) Request method. If nil, matches all methods.
 \param isTemplate Response template. If true, data is treated as tempalte.
 */
+ (void)addData:(NSData*)data code:(NSInteger)code headers:(NSDictionary*)headers forPath:(NSString*)path host:(NSString*)host method:(NSString*)method isTemplate:(BOOL)isTemplate;

/*!
 Add a fixture with response data from a string.

 \param string   Response data string.
 \param encoding String encoding.
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromString:(NSString *)string encoding:(NSStringEncoding)encoding forPath:(NSString *)path method:(NSString *)method;

/*!
 Add a fixture with response data from a string.

 \param string   Response data string.
 \param encoding String encoding.
 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromString:(NSString *)string encoding:(NSStringEncoding)encoding code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*!
 Add a fixture with response data from a Json object.

 \param json     Response data Json object.
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromJson:(NSDictionary *)json forPath:(NSString *)path method:(NSString *)method;

/*!
 Add a fixture with response data from a Json object.

 \param json     Response data Json object.
 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromJson:(NSDictionary *)json code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*!
 Add a fixture with response data read from a file path.

 \param file     Response data file path.
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromFile:(NSString *)file forPath:(NSString *)path method:(NSString *)method;

/*!
 Add a fixture with response data read from a file path.

 \param file     Response data file path.
 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromFile:(NSString *)file code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*!
 Add a fixture with response data read from a resource bundle.

 \param name     Response data resource name.
 \param bundle   Resource bundle. If nil, will use NSBundle.mainBundle().
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromResourceNamed:(NSString *)name bundle:(NSBundle *)bundle forPath:(NSString *)path method:(NSString *)method;

/*!
 Add a fixture with response data read from a resource bundle.

 \param name     Response data resource name.
 \param bundle   Resource bundle. If nil, will use NSBundle.mainBundle().
 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromResourceNamed:(NSString *)name bundle:(NSBundle *)bundle code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*!
 Add a fixture with response data read synchronously from a URL.

 \param URL      Response data URL.
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromURL:(NSURL *)URL forPath:(NSString *)path method:(NSString *)method;

/*!
 Add a fixture with response data read synchronously from a URL.

 \param URL      Response data URL.
 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromURL:(NSURL *)URL code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*!
 Add a fixture with response data returned by a block.

 \param block    Response data block.
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromBlock:(FixtureProtocolBlock)block forPath:(NSString *)path method:(NSString *)method;

/*!
 Add a fixture with response data returned by a block.

 \param block    Response data block.
 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addDataFromBlock:(FixtureProtocolBlock)block code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*!
 Add a fixture with response template from a string.
 
 \param string   Response template string.
 \param encoding String encoding.
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addTemplateFromString:(NSString *)string encoding:(NSStringEncoding)encoding forPath:(NSString *)path method:(NSString *)method;

/*!
 Add a fixture with response template from a string.
 
 \param string   Response template string.
 \param encoding String encoding.
 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addTemplateFromString:(NSString *)string encoding:(NSStringEncoding)encoding code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*!
 Add a fixture with response template from a Json object.
 
 \param json     Response template Json object.
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addTemplateFromJson:(NSDictionary *)json forPath:(NSString *)path method:(NSString *)method;

/*!
 Add a fixture with response template from a Json object.
 
 \param json     Response data Json object.
 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addTemplateFromJson:(NSDictionary *)json code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*!
 Add a fixture with response template read from a file path.
 
 \param file     Response data file path.
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addTemplateFromFile:(NSString *)file forPath:(NSString *)path method:(NSString *)method;

/*!
 Add a fixture with response template read from a file path.
 
 \param file     Response template file path.
 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addTemplateFromFile:(NSString *)file code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*!
 Add a fixture with response template read from a resource bundle.
 
 \param name     Response template resource name.
 \param bundle   Resource bundle. If nil, will use NSBundle.mainBundle().
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addTemplateFromResourceNamed:(NSString *)name bundle:(NSBundle *)bundle forPath:(NSString *)path method:(NSString *)method;

/*!
 Add a fixture with response template read from a resource bundle.
 
 \param name     Response template resource name.
 \param bundle   Resource bundle. If nil, will use NSBundle.mainBundle().
 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addTemplateFromResourceNamed:(NSString *)name bundle:(NSBundle *)bundle code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*!
 Add a fixture with response template read synchronously from a URL.
 
 \param URL      Response template URL.
 \param forPath  Request path. May contain "*" wildcards.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addTemplateFromURL:(NSURL *)URL forPath:(NSString *)path method:(NSString *)method;

/*!
 Add a fixture with response template read synchronously from a URL.
 
 \param URL      Response template URL.
 \param code     Response code.
 \param headers  (Optional) Response headers.
 \param forPath  Request path. May contain "*" wildcards.
 \param host     (Optional) Request host. May contain "*" wildcards. If nil, matches all hosts.
 \param method   (Optional) Request method. If nil, matches all methods.
 */
+ (void)addTemplateFromURL:(NSURL *)URL code:(NSInteger)code headers:(NSDictionary *)headers forPath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*!
 Add key-value pairs to scope
 
 \param keyValues key-value pairs.
 */
+ (void)addKeyValues:(NSDictionary *)keyValues;

/*!
 Removes the specified path from the current scope.

 To successfully remove a path in the current scope, the specified path, host,
 and method strings must match exactly the path used to add a fixture. If there
 are multiple fixtures registered with the same path in the current scope, only
 the first matching fixture matching the parameters is removed.

 \param path     Request path. May contain "*" wildcards.
 \param method   Request method.
 */
+ (void)removePath:(NSString *)path method:(NSString *)method;

/*!
 Removes the specified path from the current scope.

 To successfully remove a path in the current scope, the specified path, host,
 and method strings must match exactly the path used to add a fixture. If there
 are multiple fixtures registered with the same path in the current scope, only
 the first matching fixture matching the parameters is removed.

 \param path     Request path. May contain "*" wildcards.
 \param host     Request host. May contain "*" wildcards.
 \param method   Request method.
 */
+ (void)removePath:(NSString *)path host:(NSString *)host method:(NSString *)method;

/*! Removes all paths from the current scope. */
+ (void)removeAll;

#pragma mark - Public (Fixture Scope)

/*!
 Enters a new fixture scope.

 After entering a new scope, all add and remove functions apply only to the
 new scope.
 */
+ (void)enterScope;

/*!
 Exits the last entered fixture scope.

 Attempts to exit the default fixture scope are ignored.
 */
+ (void)exitScope;

@end
