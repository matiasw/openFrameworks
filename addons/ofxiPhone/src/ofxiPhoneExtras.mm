/***********************************************************************
 
 Copyright (c) 2008, 2009, Memo Akten, www.memo.tv
 *** The Mega Super Awesome Visuals Company ***
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of MSA Visuals nor the names of its contributors 
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
 * ***********************************************************************/ 


#import "ofxiPhoneExtras.h"

//--------------------------------------------------------------
ofxiPhoneDeviceType iPhoneGetDeviceType() {
	return [[[UIDevice currentDevice] model] caseInsensitiveCompare:@"iPhone"] == NSOrderedSame ? OFXIPHONE_DEVICE_IPHONE : OFXIPHONE_DEVICE_IPODTOUCH;
}


//--------------------------------------------------------------
string iPhoneGetDeviceRevision() {
	// ZACH TODO
}

//--------------------------------------------------------------
UIWindow *iPhoneGetUIWindow() {
	return [[UIApplication sharedApplication] keyWindow];
}


//--------------------------------------------------------------
EAGLView *iPhoneGetGLView() {
	return [iPhoneGetAppDelegate() getGLView];
}


//--------------------------------------------------------------
ofAppiPhoneWindow* iPhoneGetOFWindow() {
	return ofAppiPhoneWindow::getInstance();
}


//--------------------------------------------------------------
ofxiPhoneAppDelegate *iPhoneGetAppDelegate() {
	return [[UIApplication sharedApplication] delegate];
}


//--------------------------------------------------------------
void iPhoneSendGLViewToFront() {
	[iPhoneGetUIWindow() bringSubviewToFront:iPhoneGetGLView()];
}


//--------------------------------------------------------------
void iPhoneSendGLViewToBack() {
	[iPhoneGetUIWindow() sendSubviewToBack:iPhoneGetGLView()];
}


//--------------------------------------------------------------
void iPhoneSetGLViewTransparent(bool b) {
	iPhoneGetGLView().opaque = !b;
}


//--------------------------------------------------------------
void iPhoneSetGLViewUserInteraction(bool b) {
	iPhoneGetGLView().userInteractionEnabled = b;
}



//--------------------------------------------------------------
void iPhoneEnableIdleTimer() {
	[UIApplication sharedApplication].idleTimerDisabled = true;
}


//--------------------------------------------------------------
void iPhoneDisableIdleTimer() {
	[UIApplication sharedApplication].idleTimerDisabled = false;
}


//--------------------------------------------------------------
void iPhoneEnableLoopInThread() {
	[iPhoneGetAppDelegate() enableLoopInThread];
}


//--------------------------------------------------------------
void iPhoneSetOrientation(UIDeviceOrientation orientation) {
	iPhoneGetOFWindow()->setOrientation(orientation);
}


//--------------------------------------------------------------
UIDeviceOrientation iPhoneGetOrientation() {
	return (UIDeviceOrientation)iPhoneGetOFWindow()->getOrientation();;
}


//--------------------------------------------------------------
void iPhoneBundleImageToGLTexture(NSString *filename, GLuint *spriteTexture) {
	iPhoneUIImageToGLTexture([UIImage imageNamed:filename], spriteTexture);
}


//--------------------------------------------------------------
void iPhoneUIImageToGLTexture(UIImage *uiImage, GLuint *spriteTexture) {
	if(!uiImage) return;
	
	CGImageRef cgImage;
	CGContextRef spriteContext;
	GLubyte *pixels;
	size_t	width, height;
	
	// Creates a Core Graphics image from an image file
	cgImage = uiImage.CGImage;
	
	// Get the width and height of the image
	width = CGImageGetWidth(cgImage);
	height = CGImageGetHeight(cgImage);
	
	// Allocated memory needed for the bitmap context
	pixels = (GLubyte *) malloc(width * height * 4);
	// Uses the bitmatp creation function provided by the Core Graphics framework. 
	spriteContext = CGBitmapContextCreate(pixels, width, height, 8, width * 4, CGImageGetColorSpace(cgImage), kCGImageAlphaPremultipliedLast);
	// After you create the context, you can draw the sprite image to the context.
	CGContextDrawImage(spriteContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), cgImage);
	// You don't need the context at this point, so you need to release it to avoid memory leaks.
	CGContextRelease(spriteContext);
	
	// Use OpenGL ES to generate a name for the texture.
	glGenTextures(1, spriteTexture);
	// Bind the texture name. 
	glBindTexture(GL_TEXTURE_2D, *spriteTexture);
	// Speidfy a 2D texture image, provideing the a pointer to the image data in memory
	glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, pixels);
	// Release the image data
	free(pixels);
	
	// Set the texture parameters to use a minifying filter and a linear filer (weighted average)
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
}


//--------------------------------------------------------------
void iPhoneUIImageToOFImage(UIImage *uiImage, ofImage &outImage) {
	if(!uiImage) return;
	
	CGImageRef cgImage;
	CGContextRef spriteContext;
	GLubyte *pixels;
	size_t	width, height;
	int bpp = 4;
	
	// Creates a Core Graphics image from an image file
	cgImage = uiImage.CGImage;
	
	// Get the width and height of the image
	width = CGImageGetWidth(cgImage);
	height = CGImageGetHeight(cgImage);
	
	
	// Allocated memory needed for the bitmap context
	pixels = (GLubyte *) malloc(width * height * bpp);
	// Uses the bitmatp creation function provided by the Core Graphics framework. 
	spriteContext = CGBitmapContextCreate(pixels, width, height, 8, width * 4, CGImageGetColorSpace(cgImage), kCGImageAlphaPremultipliedLast);
	// After you create the context, you can draw the sprite image to the context.
	CGContextDrawImage(spriteContext, CGRectMake(0.0, 0.0, (CGFloat)width, (CGFloat)height), cgImage);
	// You don't need the context at this point, so you need to release it to avoid memory leaks.
	CGContextRelease(spriteContext);
	
	// vertically flip
	GLubyte *pixelsFlipped = (GLubyte *) malloc(width * height * bpp);
	int numBytesPerRow = width * bpp;
	for(int y=0; y<height; y++) {
		memcpy(pixelsFlipped + (numBytesPerRow * y), pixels + (numBytesPerRow * (height - 1 - y)), numBytesPerRow);
	}
	
	
	outImage.setFromPixels(pixelsFlipped, width, height, OF_IMAGE_COLOR_ALPHA, true);
	
	free(pixels);
	free(pixelsFlipped);
}

//--------------------------------------------------------------

string ofxNSStringToString(NSString * s)
{
	char newChars[ [s length]+1 ];
	
	[s getCString:newChars];
	
	return string(newChars);
}

//--------------------------------------------------------------

NSString * ofxStringToNSString(string s)
{
	return [[[NSString alloc] initWithCString: s.c_str()] autorelease];
}


/******************** ofxiPhoneScreenGrab *********************/

@interface SaveDelegate : NSObject {
	id delegate;
}
@property (retain, nonatomic) id delegate;
@end


@implementation SaveDelegate
@synthesize delegate;

// callback for UIImageWriteToSavedPhotosAlbum
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
	ofLog(OF_LOG_VERBOSE, "Save finished");
	[image release];		// release image
	if( [delegate respondsToSelector: @selector(saveComplete)]) [delegate performSelector:@selector(saveComplete)];
	
	[self release];
}

-(void)dealloc {
	[delegate release];
	[super dealloc];
}

@end



// callback for CGDataProviderCreateWithData
void releaseData(void *info, const void *data, size_t dataSize) {
	//	NSLog(@"releaseData\n");
	free((void*)data);		// free the 
}


void iPhoneScreenGrab(id delegate) {
	CGRect rect = [[UIScreen mainScreen] bounds];
	int width = rect.size.width;
	int height =  rect.size.height;
	
	NSInteger myDataLength = width * height * 4;
	GLubyte *buffer = (GLubyte *) malloc(myDataLength);
	GLubyte *bufferFlipped = (GLubyte *) malloc(myDataLength);
	glReadPixels(0, 0, width, height, GL_RGBA, GL_UNSIGNED_BYTE, buffer);
	for(int y = 0; y <height; y++) {
		for(int x = 0; x <width * 4; x++) {
			bufferFlipped[int((height - 1 - y) * width * 4 + x)] = buffer[int(y * 4 * width + x)];
		}
	}
	free(buffer);	// free original buffer
	
	CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, bufferFlipped, myDataLength, releaseData);
	CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
	CGImageRef imageRef = CGImageCreate(width, height, 8, 32, 4 * width, colorSpaceRef, kCGBitmapByteOrderDefault, provider, NULL, NO, kCGRenderingIntentDefault);		
	
	CGColorSpaceRelease(colorSpaceRef);
	CGDataProviderRelease(provider);
	
	UIImage *image = [[UIImage alloc] initWithCGImage:imageRef];
	CGImageRelease(imageRef);
	
	SaveDelegate *saveDelegate = [SaveDelegate new];
	saveDelegate.delegate = delegate;
	UIImageWriteToSavedPhotosAlbum(image, saveDelegate, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


