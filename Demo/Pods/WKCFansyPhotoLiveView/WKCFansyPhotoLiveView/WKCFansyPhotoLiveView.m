//
//  WKCPhotoLiveView.m
//  WKCPhotoLiveView
//
//  Created by 魏昆超 on 2018/10/10.
//  Copyright © 2018年 魏昆超. All rights reserved.
//

#import "WKCFansyPhotoLiveView.h"

@interface WKCFansyPhotoLiveView() <PHLivePhotoViewDelegate>

@property (nonatomic, strong) UIImageView * backgroundImageView;
@property (nonatomic, strong) PHLivePhotoView *livePhotoView;
@property (nonatomic, copy, readwrite) NSString * imageFile;
@property (nonatomic, copy, readwrite) NSString * videoFile;

@end

@implementation WKCFansyPhotoLiveView

- (instancetype)initWithRemotePlaceholdImageURL:(NSURL *)rpImageURL
                                   remoteMovURL:(NSURL *)rMovURL
{
    if (self = [super init]) {
        if(rpImageURL) {
            WKCFansyImageLoader * imageLoader = [[WKCFansyImageLoader alloc] initWithURL:rpImageURL];
            self.imageFile = imageLoader.fileURL.path;
        }
        [self makeRemoteVideoWithURL:rMovURL];

    }
    return self;
}

- (instancetype)initWithFilePlaceholdImageName:(NSString *)fpImageName
                                  remoteMovURL:(NSURL *)rMovURL
{
    if (self = [super init]) {
        if (fpImageName.length != 0) {
            WKCFansyImageLoader * imageLoader = [[WKCFansyImageLoader alloc] initWithName:fpImageName];
            self.imageFile = imageLoader.fileURL.path;
        }
        [self makeRemoteVideoWithURL:rMovURL];
        
    }
    return self;
}

- (instancetype)initWithRemotePlaceholdImageURL:(NSURL *)rpImageURL
                                     fileMovURL:(NSURL *)fMovURL
{
    if (self = [super init]) {
         self.videoFile = fMovURL.path;
        if (!rpImageURL) {
            [self makeFrameWithMovFilePath:fMovURL];
        }else {
            WKCFansyImageLoader * imageLoader = [[WKCFansyImageLoader alloc] initWithURL:rpImageURL];
            self.imageFile = imageLoader.fileURL.path;
            [self makeRequestWithImageFile:self.imageFile
                                 videoFile:fMovURL.path];
        }
    }
    return self;
}

- (instancetype)initWithFilePlaceholdImageName:(NSString *)fpImageName
                                    fileMovURL:(NSURL *)fMovURL
{
    if (self = [super init]) {
         self.videoFile = fMovURL.path;
        if (fpImageName.length == 0) {
            [self makeFrameWithMovFilePath:fMovURL];
        }else {
            WKCFansyImageLoader * imageLoader = [[WKCFansyImageLoader alloc] initWithName:fpImageName];
            self.imageFile = imageLoader.fileURL.path;
            [self makeRequestWithImageFile:self.imageFile
                                 videoFile:fMovURL.path];
        }
    
    }
    return self;
}

#pragma mark - 转换Mov生成livePhoto
- (void)makeFrameWithMovFilePath:(NSURL *)URL
{
    if (![URL.path.lastPathComponent.pathExtension containsString:@"mov"] && ![URL.path.lastPathComponent.pathExtension containsString:@"MOV"]) {
        
        NSString * name = [URL.path.lastPathComponent stringByDeletingPathExtension];
        NSString * savePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",name]];
        
        [WKCFansyMovTransformer transformerWithVideoURL:URL
                                               savePath:savePath completionHandle:^(WKCFansyMovTransformerState state) {
                                              if (state == WKCFansyMovTransformerStateAllCompleted) {
                                                  [self makeImageFramerWithURL:[NSURL fileURLWithPath:savePath]];
                                              }
                                              if ([self isCanPostDelegateWithSEL:@selector(fansyPhotoLiveView:transformState:)]) {
                                                  [self.delegate fansyPhotoLiveView:self
                                                                   transformState:state];
                                              }
                                          }];
        return;
    }else {
        [self makeImageFramerWithURL:URL];
    }
    
}

- (void)makeImageFramerWithURL:(NSURL *)URL
{
    [WKCFansyImageFramer imageFramerWithMovFilePath:URL
                                   completionHandle:^(BOOL isSuccess, NSString * imagePath) {
                                  if (isSuccess) {
                                      self.imageFile = imagePath;
                                      [self makeRequestWithImageFile:self.imageFile
                                                           videoFile:URL.path];
                                  }else {
                                      NSLog(@"获取视频帧图片失败!");
                                  }
                              }];
}

- (void)makeRemoteVideoWithURL:(NSURL *)video
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString * name = [video.lastPathComponent stringByDeletingPathExtension];
    NSString *videoFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",name]];
    self.videoFile = videoFilePath;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:videoFilePath]) {
        [self makeRequestWithImageFile:self.imageFile
                             videoFile:self.videoFile];
        return;
    }

    [WKCFansyDownloadManager downloadFileWithURL:video
                                    saveFilePath:videoFilePath
                                  progressHandle:^(CGFloat progress) {
                                 if ([self isCanPostDelegateWithSEL:@selector(fansyPhotoLiveView:downloadingProgress:)]) {
                                     [self.delegate fansyPhotoLiveView:self downloadingProgress:progress];
                                 }
    } completionHandle:^(BOOL isSuccess) {
        if (isSuccess) {
            [self makeRequestWithImageFile:self.imageFile
                                 videoFile:self.videoFile];
        }else {
            NSLog(@"Remote video downloaded failed!");
        }
        if ([self isCanPostDelegateWithSEL:@selector(fansyPhotoLiveView:downloadedState:)]) {
            [self.delegate fansyPhotoLiveView:self downloadedState:!isSuccess];
        }
    }];
}

- (void)makeRequestWithImageFile:(NSString *)imageFilePath
                       videoFile:(NSString *)videoFilePath
{
    [WKCFansyLivePhotoRequest requestWithImageFile:imageFilePath
                                         videoFile:videoFilePath
                                      resultHandle:^(PHLivePhoto * livePhoto, NSDictionary * info) {
                                     
                                     if (!livePhoto) {
                                        NSLog(@"livePhoto shows error: %@",[info objectForKey:PHLivePhotoInfoErrorKey]);
                                         NSLog(@"trying to framer mov once...");
                                         static BOOL tryOnce = YES;
                                         if (tryOnce) {
                                             tryOnce = NO;
                                             [self makeFrameWithMovFilePath:[NSURL fileURLWithPath:self.videoFile]];
                                         }
                                         NSLog(@"framer mov to livePhoto failed!...");
                                         return;
                                     }
                                     
                                     [self makePlayWithLivePhoto:livePhoto
                                                 backgroundImage:[UIImage imageWithContentsOfFile:imageFilePath]];
                                 }];
}

- (void)makePlayWithLivePhoto:(PHLivePhoto *)livePhoto
              backgroundImage:(UIImage *)bgimage
{
    self.livePhotoView.livePhoto = livePhoto;
    [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
    self.backgroundImageView.image = bgimage;
}

- (BOOL)isCanPostDelegateWithSEL:(SEL)sel
{
    return self.delegate && [self.delegate respondsToSelector:sel];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self initliazeProperty];
        
        [self addSubview:self.backgroundImageView];
        [self addSubview:self.livePhotoView];
    
        [self addLayoutForItem:self.backgroundImageView];
        [self addLayoutForItem:self.livePhotoView];
        
    }
    return self;
}

- (void)setLiveMode:(UIViewContentMode)liveMode
{
    _liveMode = liveMode;
    self.livePhotoView.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)setMuted:(BOOL)muted
{
    _muted = muted;
    self.livePhotoView.muted = muted;
}

- (void)initliazeProperty
{
    self.liveMode = UIViewContentModeScaleAspectFill;
    self.muted = NO;
}

#pragma mark - PHLivePhotoViewDelegate
- (void)livePhotoView:(PHLivePhotoView *)livePhotoView willBeginPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle
{
    if ([self isCanPostDelegateWithSEL:@selector(fansyPhotoLiveViewWillBeginPlay:)]) {
        [self.delegate fansyPhotoLiveViewWillBeginPlay:self];
    }
}

- (void)livePhotoView:(PHLivePhotoView *)livePhotoView didEndPlaybackWithStyle:(PHLivePhotoViewPlaybackStyle)playbackStyle
{
    if ([self isCanPostDelegateWithSEL:@selector(fansyPhotoLiveViewDidEndPlay:)]) {
        [self.delegate fansyPhotoLiveViewDidEndPlay:self];
    }
}

- (void)replay
{
    [self.livePhotoView startPlaybackWithStyle:PHLivePhotoViewPlaybackStyleFull];
}

- (void)stopPlay
{
    [self.livePhotoView stopPlayback];
}

- (void)saveToLibrary
{
    [WKCFansyLivePhotoSaver saveWithImageFile:self.imageFile
                                    videoFile:self.videoFile
                                 resultHandle:^(WKCFansyLivePhotoSaverState state) {
        if ([self isCanPostDelegateWithSEL:@selector(fansyPhotoLiveView:saveToLibraryWithState:)]) {
            [self.delegate fansyPhotoLiveView:self saveToLibraryWithState:state];
        }
    }];
}

- (void)touchOnMyself
{
    if ([self isCanPostDelegateWithSEL:@selector(fansyPhotoLiveViewDidTouch:)]) {
        [self.delegate fansyPhotoLiveViewDidTouch:self];
    }
}

#pragma mark - Property
- (UIImageView *)backgroundImageView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _backgroundImageView.contentMode = self.liveMode;
        _backgroundImageView.clipsToBounds = YES;
    }
    return _backgroundImageView;
}

- (PHLivePhotoView *)livePhotoView 
{
    if (!_livePhotoView) {
        _livePhotoView = [[PHLivePhotoView alloc] initWithFrame:self.bounds];
        _livePhotoView.backgroundColor = [UIColor clearColor];
        _livePhotoView.contentMode = self.liveMode;
        _livePhotoView.layer.masksToBounds = YES;
        _livePhotoView.muted = self.muted;
        _livePhotoView.userInteractionEnabled = YES;
        _livePhotoView.delegate = self;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOnMyself)];
        [_livePhotoView addGestureRecognizer:tap];
    }
    return _livePhotoView;
}

#pragma mark - layout
- (void)addLayoutForItem:(UIView *)item
{
    item.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *t = [NSLayoutConstraint constraintWithItem:item
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTop
                                                        multiplier:1.f
                                                          constant:0];
    
    NSLayoutConstraint *l = [NSLayoutConstraint constraintWithItem:item
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.f
                                                          constant:0];
    
    NSLayoutConstraint *b = [NSLayoutConstraint constraintWithItem:item
                                                         attribute:NSLayoutAttributeBottom
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.f
                                                          constant:0];
    
    NSLayoutConstraint *r = [NSLayoutConstraint constraintWithItem:item
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.f
                                                          constant:0];
    t.active = YES;
    l.active = YES;
    b.active = YES;
    r.active = YES;
    
    [self addConstraints:@[t,l,b,r]];
}

@end
