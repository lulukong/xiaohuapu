//
//  DianJoyAjaxClient.m
//  DianJoyAdLib
//
//  Created by kaiyang on 11/22/09.
//  Copyright 2009 DianJoy. All rights reserved.
//

#import "DianJoyAjaxClient.h"
#import "JSON.h"

static NSString *DianJoyURLEncode(id object) {
    NSString *string = [NSString stringWithFormat: @"%@", object];;
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}

@implementation DianJoyAjaxClient

@synthesize url = _url;
@synthesize delegate = _delegate;
@synthesize onSuccessSelector = _onSuccessSelector;
@synthesize onFailSelector = _onFailSelector;

- (id)init {
    self = [super init];
    if (self) {
	_inProcess = NO;
	_receivedData = [[NSMutableData alloc] init];
    }
    return self;
}

- (void)dealloc
{
    _delegate = nil;
    [_receivedData release];
    [super dealloc];
}

-(void)doAjaxWithURL:(NSString *)aURL type:(NSString *)type data:(NSDictionary *)data {
    if (_inProcess) {
	return;
    }
    NSString* urlString = aURL;
    NSString* qstr = nil;
    // check type for GET|POST
    if (data != nil) {
	qstr = [self urlEncodedString:data];
	if ([type isEqualToString:@"GET"]) {
	    // generate the query string, append ?k1=v1&k2=v2... to the URL
	    urlString = [NSString stringWithFormat:@"%@?%@", aURL, qstr];
//	    NSLog(@"requestString:%@" , urlString);
	}
    }
    NSURL *myURL = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:myURL];
    [request setHTTPMethod:type];
    if ([type isEqualToString:@"POST"]) {
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
        if (qstr != nil) {	    
            NSData *postData = [NSData dataWithBytes:[qstr UTF8String] 
					      length:[qstr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
            NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
            [request setHTTPBody:postData];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        }
    }
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData];
    [request setTimeoutInterval: 10.f];//设置超时时间为10s
    _urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
    [request release];
}

#pragma mark - set delegate

-(void)setDelegate:(id)obj onSuccess:(SEL)onSuccessFunc onFail:(SEL)onFailFunc {
    self.delegate = obj;
    self.onSuccessSelector = onSuccessFunc;
    self.onFailSelector = onFailFunc;
}

#pragma mark - delegate for NSURLConnection

- (NSURLRequest *)connection:(NSURLConnection *)inConnection willSendRequest:(NSURLRequest *)inRequest redirectResponse:(NSURLResponse *)inResponse
{
    return (inRequest);
}

/**
 * Handle the response header.
 */
- (void)connection:(NSURLConnection *)inConnection didReceiveResponse:(NSURLResponse *)inResponse
{
//    NSLog(@"DID RECEIVE RESPONSE");
        
    [_receivedData setLength:0];
}

/**
 * Receiving data chunk.
 */
- (void)connection:(NSURLConnection *)inConnection didReceiveData:(NSData *)inData
{
    // NSLog(@"DID RECEIVE DATA");
    [_receivedData appendData:inData];
}

/**
 * Donwload is done.
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)inConnection {
    [inConnection release];
    _urlConnection = nil;
    NSDictionary* ajaxData = [[[NSMutableDictionary alloc] init] autorelease];
    
    NSString *responseString = [[NSString alloc] initWithData:_receivedData encoding:NSUTF8StringEncoding];      

//	NSLog(@"responseString: %@", responseString);
    
    // parse json string
    NSError *error;
    DianJoySBJson *json = [[DianJoySBJson new] autorelease];
    NSDictionary *jsonData = [json objectWithString:responseString error:&error];
    if (!jsonData) {
	//NSLog(@"parsing jsondata error: %@\ndata:", error, responseString);
        return;
    }
    [ajaxData setValue:jsonData forKey:@"data"];
    [responseString release];
    // callback the onSuccessSelector
    if (_delegate && _onSuccessSelector) {
        [_delegate performSelector:_onSuccessSelector withObject:ajaxData];
    }
}

- (void)connection:(NSURLConnection *)inConnection didFailWithError:(NSError *)inError
{
    [inConnection release];
    _urlConnection = nil;
    // callback the onFailSelector
    if (_delegate && _onFailSelector) {
        [_delegate performSelector:_onFailSelector withObject:inError];
    }
}

- (void)cancelHttpRequestImmediately
{
    if (_urlConnection) {
        [_urlConnection cancel];
        [_urlConnection release];
        _urlConnection = nil;
        if (_delegate && _onFailSelector) {
            NSError *error = [NSError errorWithDomain:@"com.dianjoy.iosSDK" code:4004 userInfo:[NSDictionary dictionaryWithObject:@"Http request was canceled" forKey:NSLocalizedDescriptionKey]];
            [_delegate performSelector:_onFailSelector withObject:error];
        }
    }

}

// encode NSDictionary
-(NSString*) urlEncodedString:(NSDictionary *)hash {
    if (hash == nil) {
	return @"";
    }

    NSMutableArray *parts = [NSMutableArray array];
    for (id key in hash) {
	id value = [hash objectForKey: key];
	NSString *part = [NSString stringWithFormat: @"%@=%@", 
			  DianJoyURLEncode(key), DianJoyURLEncode(value)];
	[parts addObject: part];
    }
    return [parts componentsJoinedByString: @"&"];
}

@end
