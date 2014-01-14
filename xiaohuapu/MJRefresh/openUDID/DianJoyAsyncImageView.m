//
//  DianJoyAsyncImageView
//  DianJoyAsyncImageView
//
//  Created by Jesse Bunch on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DianJoyAsyncImageView.h"

#pragma mark - *** Private Interface ***

@interface DianJoyAsyncImageView()
@property(nonatomic,strong) NSURLConnection *imageConnection;
@property(nonatomic,strong) NSURLRequest *imageRequest;

-(void)initializeClass;

@end

@implementation DianJoyAsyncImageView

@synthesize 
imageURL = imageURL_,
cachesImage = cachesImage_,
imageData = imageData_,
downloadTimeoutInterval = downloadTimeoutInterval_,
imageConnection = imageConnection_,
imageRequest = imageRequest_,
mimeTypesAllowed = mimeTypesAllowed_,
delegate = delegate_,
imageResponse = imageResponse_;

#pragma mark - *** Initializaers ***

/**
 * Designated initializer for this class
 * @author Jesse Bunch
 **/
-(id)initWithURL:(NSURL *)urlToLoad {
	
	if ((self = [super init])) {
		[self initializeClass];
		self.imageURL = urlToLoad;
	}
	
	return self;
	
}

/**
 * Designated initializer for super class
 * @author Jesse Bunch
 **/
- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
	
	if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
		[self initializeClass];
	}
	
	return self;
	
}

/**
 * Init.
 * @author Jesse Bunch
 **/
- (id)initWithImage:(UIImage *)image {
	return [self initWithImage:image highlightedImage:nil];
}

/**
 * Make sure to call necessary initialization when loaded from a nib.
 * @author Jesse Bunch
 **/
-(void)awakeFromNib {
	[super awakeFromNib];
	[self initializeClass];
}

/**
 * Class initialization
 * @author Jesse Bunch
 **/
-(void)initializeClass {
	self.mimeTypesAllowed = [NSArray arrayWithObjects:@"image/png", @"image/jpeg", @"image/jpg", @"image/gif", nil];
	self.cachesImage = YES;
	self.downloadTimeoutInterval = 15.0f;
}


#pragma mark - *** Asynchronous Image Loading ***

/**
 * Overrides setter to begin NSURLConnection
 * @author Jesse Bunch
 **/
-(void)setImageURL:(NSURL *)imageURL {
	
	// Show loading
	
	// Notify delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(imageView:willLoadImageFromURL:)]) {
		[self.delegate imageView:self willLoadImageFromURL:imageURL];
	}
	
	// Create request
	self.imageRequest = [[NSURLRequest alloc] initWithURL:imageURL 
											  cachePolicy:(self.cachesImage) ? NSURLRequestReturnCacheDataElseLoad : NSURLRequestReloadIgnoringLocalCacheData 
										  timeoutInterval:self.downloadTimeoutInterval];
	
	// Begin download
	self.imageData = nil;
	self.imageConnection = [[NSURLConnection alloc] initWithRequest:self.imageRequest 
														   delegate:self 
												   startImmediately:YES];
	
	imageURL_ = imageURL;
	
}

#pragma mark - *** NSURLConnectionDelegate ***

/**
 * If the download fails, notify the delegate and reset the image view
 * @author Jesse Bunch
 **/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	// Reset image view
//	NSLog(@"Error loading image: %@", [error localizedDescription]);
	
	// Notify delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(imageView:failedLoadingImageFromURL:withError:)]) {
		[self.delegate imageView:self failedLoadingImageFromURL:self.imageURL withError:error];
	}
	
}

/**
 * Process the received response, performing various validation methods
 * @author Jesse Bunch
 **/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	NSError *validationError = nil;
	imageResponse_ = response;
	
	// Validate MIME type
	if ([self.mimeTypesAllowed count] && ![self.mimeTypesAllowed containsObject:response.MIMEType]) {
		
		// Mime invalid, cancel download
//		NSLog(@"MIME type returned is not allowed: %@", response.MIMEType);
		[self.imageConnection cancel];
		
		// Error for delegate
		validationError = [NSError errorWithDomain:@"com.dianjoy.asyncImage" 
											  code:406 
										  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
													[NSString stringWithFormat:@"MIME type is not allowed: %@", response.MIMEType], NSLocalizedDescriptionKey, nil]];
		
	}
	
	// Error? Notify the delegate.
	if (validationError) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(imageView:failedLoadingImageFromURL:withError:)]) {
			[self.delegate imageView:self failedLoadingImageFromURL:self.imageURL withError:validationError];
		}
	}
	
}

/**
 * Incremental data received
 * @author Jesse Bunch
 **/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	// Create bucket if it doesn't exist.
	if (!imageData_) {
		imageData_ = [[NSMutableData alloc] init];
	}
	
	// Add to the bucket.
	[imageData_ appendData:data];
	
}

/**
 * Loading was a success!
 * @author Jesse Bunch
 **/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	// Create image from data
	self.image = [UIImage imageWithData:imageData_];
	
	// Notify the delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(imageView:loadedImage:fromURL:)]) {
		[self.delegate imageView:self loadedImage:self.image fromURL:self.imageURL];
	}
	
}

@end
