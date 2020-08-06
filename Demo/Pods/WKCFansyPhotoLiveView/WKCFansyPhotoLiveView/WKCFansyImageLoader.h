//
//  WKCImageLoader.h
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/9/30.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WKCFansyImageLoader : NSObject

/// 初始化 - remote图片
/// @param URL 图片URL
- (instancetype)initWithURL:(NSURL *)URL;

/// 初始化 - native图片
/// @param name name 图片name
- (instancetype)initWithName:(NSString *)name;

/// 图片的fileURL
@property (nonatomic, copy, readonly) NSURL * fileURL;

/// 图片对象
@property (nonatomic, strong, readonly) UIImage * image;

@end

