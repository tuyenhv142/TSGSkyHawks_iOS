//
//  EGPhotoCollectionViewCell.h
//  EagleBaseballTeam
//
//  Created by elvin on 2025/6/16.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVPlayerItem.h>
#import <AVFoundation/AVPlayer.h>
#import <AVFoundation/AVPlayerLayer.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView;

@end


@interface PhotoLabelCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) UIImageView *imageView_private;

@property (nonatomic, strong) AVPlayer * _Nullable player;
@property (nonatomic, strong) AVPlayerLayer * _Nullable playerLayer;
//@property (nonatomic, strong) AVPlayerItem * _Nullable playerItem;

@property (nonatomic, strong) NSURL *videoURL;

@property (nonatomic, copy) void (^playVideoBlock)(void);
// 配置视频URL，但不立即播放
- (void)configureWithURL:(NSURL *)videoURL;

// 开始播放
- (void)play;

// 停止播放
- (void)stop;



- (void)playTmp;

- (void)pauseTmp;

@end

NS_ASSUME_NONNULL_END
