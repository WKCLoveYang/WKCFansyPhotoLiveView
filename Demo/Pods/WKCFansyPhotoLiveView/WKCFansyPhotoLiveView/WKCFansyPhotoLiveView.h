//
//  WKCPhotoLiveView.h
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/10/10.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "WKCFansyDownloadManager.h"
#import "WKCFansyLivePhotoRequest.h"
#import "WKCFansyImageLoader.h"
#import "WKCFansyLivePhotoSaver.h"
#import "WKCFansyImageFramer.h"
#import "WKCFansyMovTransformer.h"

/**
 下载状态
 */
typedef NS_ENUM(NSInteger, WKCPhotoLiveDownloadedState) {
    /**下载成功*/
    WKCPhotoLiveDownloadedStateSuccess = 0,
    /**下载错误*/
    WKCPhotoLiveDownloadedStateError
};

@class WKCFansyPhotoLiveView;

@protocol WKCFansyPhotoLiveViewDelegate <NSObject>

@optional

/// 远程视频下载中...
/// @param liveView WKCFansyPhotoLiveView
/// @param progress 下载进度
- (void)fansyPhotoLiveView:(WKCFansyPhotoLiveView *)liveView
       downloadingProgress:(CGFloat)progress;

/// 远程视频结束...
/// @param liveView WKCFansyPhotoLiveView
/// @param state 结束状态
- (void)fansyPhotoLiveView:(WKCFansyPhotoLiveView *)liveView
           downloadedState:(WKCPhotoLiveDownloadedState)state;

/// 格式转换 - 非mov格式调用
/// @param liveView WKCFansyPhotoLiveView
/// @param state 转换状态
- (void)fansyPhotoLiveView:(WKCFansyPhotoLiveView *)liveView
            transformState:(WKCFansyMovTransformerState)state;

/// 点击当前视图
/// @param liveView WKCFansyPhotoLiveView
- (void)fansyPhotoLiveViewDidTouch:(WKCFansyPhotoLiveView *)liveView;

/// livePhoto将要播放
/// @param liveView WKCFansyPhotoLiveView
- (void)fansyPhotoLiveViewWillBeginPlay:(WKCFansyPhotoLiveView *)liveView;

/// livePhoto播放完毕
/// @param liveView WKCFansyPhotoLiveView
- (void)fansyPhotoLiveViewDidEndPlay:(WKCFansyPhotoLiveView *)liveView;

/// 保存到图库
/// @param liveView WKCFansyPhotoLiveView
/// @param state 保存状态
- (void)fansyPhotoLiveView:(WKCFansyPhotoLiveView *)liveView
    saveToLibraryWithState:(WKCFansyLivePhotoSaverState)state;

@end



@interface WKCFansyPhotoLiveView : UIView

/// 代理
@property (nonatomic, weak) id<WKCFansyPhotoLiveViewDelegate> delegate;

/// 展示模式 - 默认平铺
@property (nonatomic, assign) UIViewContentMode liveMode;

/// 是否消音 - 默认NO
@property (nonatomic, assign) BOOL muted;

/// 图片的存储位置 - 只读
@property (nonatomic, copy, readonly) NSString * imageFile;

/// video的存储位置 - 只读
@property (nonatomic, copy, readonly) NSString * videoFile;

/// 初始化
/// @param rpImageURL 远程图片
/// @param rMovURL 远程视频
- (instancetype)initWithRemotePlaceholdImageURL:(NSURL *)rpImageURL
                        remoteMovURL:(NSURL *)rMovURL;

/// 初始化
/// @param fpImageName 本地图片
/// @param rMovURL 远程视频
- (instancetype)initWithFilePlaceholdImageName:(NSString *)fpImageName
                       remoteMovURL:(NSURL *)rMovURL;

/// 初始化
/// @param rpImageURL 远程图片
/// @param fMovURL 本地视频
- (instancetype)initWithRemotePlaceholdImageURL:(NSURL *)rpImageURL
                          fileMovURL:(NSURL *)fMovURL;

/// 初始化
/// @param fpImageName 本地图片
/// @param fMovURL 本地视频
- (instancetype)initWithFilePlaceholdImageName:(NSString *)fpImageName
                         fileMovURL:(NSURL *)fMovURL;

/// 重放
- (void)replay;

/// 停止播放
- (void)stopPlay;

/// 保存到图库
- (void)saveToLibrary;


@end

