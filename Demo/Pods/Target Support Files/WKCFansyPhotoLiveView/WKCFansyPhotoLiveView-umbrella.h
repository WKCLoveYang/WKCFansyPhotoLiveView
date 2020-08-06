#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "WKCFansyDownloadManager.h"
#import "WKCFansyImageFramer.h"
#import "WKCFansyImageLoader.h"
#import "WKCFansyImageMaker.h"
#import "WKCFansyLivePhotoRequest.h"
#import "WKCFansyLivePhotoSaver.h"
#import "WKCFansyMovMaker.h"
#import "WKCFansyMovTransformer.h"
#import "WKCFansyPhotoLiveView.h"

FOUNDATION_EXPORT double WKCFansyPhotoLiveViewVersionNumber;
FOUNDATION_EXPORT const unsigned char WKCFansyPhotoLiveViewVersionString[];

