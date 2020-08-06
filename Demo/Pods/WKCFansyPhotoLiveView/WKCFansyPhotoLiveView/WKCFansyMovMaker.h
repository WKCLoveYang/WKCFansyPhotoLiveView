//
//  WKCMovMake.h
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/9/30.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface WKCFansyMovMaker : NSObject

/// 初始化MOV生成器
/// @param fileURL video地址
- (instancetype)initWithFileURL:(NSURL *)fileURL;

/// 获取Mov视频的标识
- (NSString *)readAssetIdentify;

/// 获取Mov视频对应的静图帧数
- (NSNumber *)readStillImageTime;

@end

