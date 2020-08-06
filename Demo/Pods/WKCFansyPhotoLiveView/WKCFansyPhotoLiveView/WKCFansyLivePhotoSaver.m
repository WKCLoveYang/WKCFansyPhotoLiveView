//
//  WKCLIvePhotoSaver.m
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/10/3.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import "WKCFansyLivePhotoSaver.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>

@implementation WKCFansyLivePhotoSaver

+ (void)saveWithImageFile:(NSString *)imageF
                videoFile:(NSString *)videoF
             resultHandle:(void(^)(WKCFansyLivePhotoSaverState state))result
{
    if (imageF.length == 0) {
        if (result) result(WKCFansyLivePhotoSaverStateError);
        return;
    }
    
    __block BOOL _isCanBlock = NO;
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized) {
        _isCanBlock = YES;
    } else {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            _isCanBlock = status == PHAuthorizationStatusAuthorized ? YES : NO;
        }];
    }
    
    if (!_isCanBlock) {
        if (result) result(WKCFansyLivePhotoSaverStateNotAccessOpen);
        return;
    }
    
    NSURL * imageURL = [NSURL fileURLWithPath:imageF];
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetCreationRequest * request = [PHAssetCreationRequest creationRequestForAsset];
        [request addResourceWithType:PHAssetResourceTypePhoto
                             fileURL:imageURL
                             options:nil];
        if (videoF.length != 0) {
            NSURL * videoURL = [NSURL fileURLWithPath:videoF];
            [request addResourceWithType:PHAssetResourceTypePairedVideo
                                 fileURL:videoURL
                                 options:nil];  
        }
    } completionHandler:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                NSLog(@"LivePhtotos 已经保存到图库!");
                if (result) result(WKCFansyLivePhotoSaverStateSuccess);
            } else {
                NSLog(@"保存出错了, error:%@",error);
                if (result) result(WKCFansyLivePhotoSaverStateError);
            }
        });
    }];
}

@end
