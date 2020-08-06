//
//  WKCLIvePhotoSaver.h
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/10/3.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,WKCFansyLivePhotoSaverState) {
    /**保存成功*/
    WKCFansyLivePhotoSaverStateSuccess = 0,
    /**保存失败*/
    WKCFansyLivePhotoSaverStateError ,
    /**图库权限没开*/
    WKCFansyLivePhotoSaverStateNotAccessOpen
};

@interface WKCFansyLivePhotoSaver : NSObject

/// 保存LivePhoto到图库
/// @param imageF 图片本地地址
/// @param videoF video本地地址
/// @param result 状态结果回调
+ (void)saveWithImageFile:(NSString *)imageF
                videoFile:(NSString *)videoF
             resultHandle:(void(^)(WKCFansyLivePhotoSaverState state))result;

@end
