//
//  DianJoyAjaxClient.h
//  DianJoyAdLib
//
//  Created by kaiyang on 11/22/09.
//  Copyright 2009 DianJoy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DianJoyAjaxClient : NSObject <NSURLConnectionDelegate>{

@private    
    // callback object
    id _delegate;
    
    // callback method for onSuccess
    SEL _onSuccessSelector;
    
    // callback method for onFail
    SEL _onFailSelector;
    
    NSString* _url;
    
    // current request is in process
    BOOL _inProcess;
    
    // received data
    NSMutableData* _receivedData;
    
    //request http server
    NSURLConnection *_urlConnection;
}

@property(assign) SEL onSuccessSelector;
@property(assign) SEL onFailSelector;
@property(assign) id delegate;
@property(retain) NSString* url;

-(void)setDelegate:(id)delegate onSuccess:(SEL)onSuccessFunc onFail:(SEL)onFailFunc;

// will handle one request at a time.
-(void)doAjaxWithURL:(NSString *)aURL type:(NSString *)type data:(NSDictionary *)data;

// encode a NSDictionary
-(NSString*) urlEncodedString:(NSDictionary *)hash;

-(void)cancelHttpRequestImmediately;

@end