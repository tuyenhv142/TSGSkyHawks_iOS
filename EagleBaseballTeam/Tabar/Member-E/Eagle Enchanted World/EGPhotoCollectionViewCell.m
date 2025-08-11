//
//  EGPhotoCollectionViewCell.m
//  EagleBaseballTeam
//
//  Created by elvin on 2025/6/16.
//  Copyright © 2025 NewSoft. All rights reserved.
//

#import "EGPhotoCollectionViewCell.h"
#import <AVFoundation/AVAssetImageGenerator.h>
#import <AVFoundation/AVAsset.h>

@interface EGPhotoCollectionViewCell ()



@property (nonatomic,strong) UIImageView *playImageView;
@property (nonatomic,strong) UIButton *heartButton;
@end

@implementation EGPhotoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageView = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.image = [UIImage imageNamed:@"3x_TAKAMEI"];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.bottom.mas_equalTo(0);
            }];
            imageView;
        });
        
        _heartButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"Vector (1)"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"Vector"] forState:UIControlStateSelected];
            [button setTitle:@"0" forState:UIControlStateNormal];
            [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
//            [button addTarget:self action:@selector(capturePhoto) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(ScaleW(20));
                make.left.mas_equalTo(ScaleW(5));
                make.bottom.mas_equalTo(-ScaleW(5));
            }];
            button;
        });
        
        
//        _playImageView = ({
//            UIImageView *imageView = [[UIImageView alloc] init];
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            imageView.clipsToBounds = YES;
//            imageView.image = [UIImage imageNamed:@"mingcute_video-fill-small"];
//            [self.contentView addSubview:imageView];
//            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.mas_equalTo(0);
//                make.centerY.mas_equalTo(0);
//                make.width.mas_equalTo(ScaleW(18));
//                make.height.mas_equalTo(ScaleW(16));
//            }];
//            imageView;
//        });
        
    }
    return self;
}
@end




@interface PhotoLabelCollectionViewCell ()


@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIButton *heartButton;
@property (nonatomic,strong) UIButton *playButton;

@property (nonatomic, strong) UIView *playerView;

@end


@implementation PhotoLabelCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.contentView.backgroundColor = UIColor.whiteColor;
        
        _playerView = ({
            UIView *view = [UIView new];
            view.backgroundColor = UIColor.blackColor;
            view.userInteractionEnabled = true;
            [self.contentView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(Device_Width);
            }];
            view;
        });
        
        _imageView_private = ({
            UIImageView *imageView = [[UIImageView alloc] init];
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.userInteractionEnabled = true;
            imageView.clipsToBounds = YES;
            imageView.image = [UIImage imageNamed:@"3x_TAKAMEI"];
            [self.contentView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(Device_Width);
            }];
            imageView;
        });
        
        _heartButton = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setImage:[UIImage imageNamed:@"Vector (3)"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"Vector (2)"] forState:UIControlStateSelected];
            [button setTitle:@"0" forState:UIControlStateNormal];
            [button setTitleColor:rgba(0, 122, 96, 1) forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:UIFontWeightRegular];
//            [button addTarget:self action:@selector(capturePhoto) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(ScaleW(20));
                make.left.mas_equalTo(ScaleW(5));
                make.top.equalTo(_playerView.mas_bottom).offset(ScaleW(5));
            }];
            button;
        });
        
        _titleLabel = ({
            UILabel *titleLabel = [UILabel new];
            titleLabel.text = @"捕捉 TAKAO";
            titleLabel.textColor = rgba(0, 122, 96, 1);
            titleLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightRegular)];
            [self.contentView addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_heartButton.mas_bottom).offset(ScaleW(5));
                make.left.mas_equalTo(ScaleW(5));
            }];
            titleLabel;
        });
        
        _timeLabel = ({
            UILabel *timeLabel = [UILabel new];
            timeLabel.text = @"2025/05/01";
            timeLabel.textColor = rgba(163, 163, 163, 1);
            timeLabel.font = [UIFont systemFontOfSize:FontSize(14) weight:(UIFontWeightRegular)];
            [self.contentView addSubview:timeLabel];
            [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_imageView_private.mas_bottom).offset(ScaleW(5));
                make.right.mas_equalTo(-ScaleW(5));
            }];
            timeLabel;
        });
        
//        _playButton = ({
//            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button setImage:[UIImage imageNamed:@"mingcute_video-fill"] forState:UIControlStateNormal];
//            button.userInteractionEnabled = true;
//            [button addTarget:self action:@selector(playVideoForIndexCell) forControlEvents:UIControlEventTouchUpInside];
//            [self.contentView addSubview:button];
//            [button mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.centerX.equalTo(_playerView.mas_centerX);
//                make.centerY.equalTo(_playerView.mas_centerY);
//                make.width.mas_equalTo(ScaleW(55));
//                make.height.mas_equalTo(ScaleW(50));
//            }];
//            button;
//        });
        
    }
    return self;
}
-(void)playVideoForIndexCell
{
    if (self.playVideoBlock) {
        self.playVideoBlock();
    }
}

- (void)configureWithURL:(NSURL *)videoURL {
    
    self.videoURL = videoURL;
    
    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_async(serialQueue, ^{
        NSURL *sourceURL = videoURL;
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
        
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:sourceURL options:opts];
//        CMTime time = [asset duration];
//        CGFloat second = ceilf(time.value/time.timescale);
    //    totalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", (int)second / 60, (int)second % 60];
        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        gen.appliesPreferredTrackTransform = YES;
        CMTime now = CMTimeMakeWithSeconds(1.0, 600); //第i帧  帧率 player.currentTime;
        [gen setRequestedTimeToleranceAfter:kCMTimeZero];
        [gen setRequestedTimeToleranceBefore:kCMTimeZero];
        CGImageRef image = [gen copyCGImageAtTime:now actualTime:NULL error:NULL];
        UIImage *thumb = [[UIImage alloc] initWithCGImage:image];
        if (image) {
            CFRelease(image);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView_private.image = thumb;
        });
    });

    
}

- (void)play {
    ELog(@"-----------play");
    self.imageView_private.hidden = true;
    self.playButton.hidden = true;
    
    
    if (!self.videoURL) {
        ELog(@"----videoURL-------is nil");
        return;
    }
    // 如果player已存在，先停止并清空
    if (self.player) {
        [self stop];
    }

    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:self.videoURL];
    
//    // 添加 status 属性观察
//    [self.playerItem addObserver:self
//                forKeyPath:@"status"
//                   options:NSKeyValueObservingOptionNew
//                   context:nil];
//    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.playerView.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.playerView.layer addSublayer:self.playerLayer];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
            [self.player play];
        }];
    });
    
    // 添加播放完成的通知，以便可以做一些清理工作或循环播放
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
//    // 添加准备就绪通知
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(playerItemDidReachEnd:)
//                                               name:AVPlayerItemNewAccessLogEntryNotification
//                                             object:playerItem];
}

-(void)playerItemDidReachEnd:(NSNotification *)notification
{
    [self.player play];
    // 播放完成后移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:AVPlayerItemNewAccessLogEntryNotification
                                                object:self.player.currentItem];
}

//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if (object == self.playerItem && [keyPath isEqualToString:@"status"]) {
//        if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
//            // 资源准备就绪，开始播放
//            [self.player play];
//        } else if (self.playerItem.status == AVPlayerItemStatusFailed) {
//            // 加载失败，处理错误
//            NSLog(@"播放失败：%@", self.playerItem.error);
//        }
//    }
//}


- (void)stop {
    ELog(@"-----------stop");
    self.imageView_private.hidden = false;
    self.playButton.hidden = false;
    
    if (self.player) {
        [self.player pause];
        self.player = nil;
    }
    if (self.playerLayer) {
        [self.playerLayer removeFromSuperlayer];
        self.playerLayer = nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)playTmp;
{ELog(@"-----------playTmp");
    self.imageView_private.hidden = true;
    self.playButton.hidden = true;
    if (self.player) {
        [self.player play];
    }
}
- (void)pauseTmp
{ELog(@"-----------pauseTmp");
    self.imageView_private.hidden = true;
    self.playButton.hidden = false;
    if (self.player) {
        [self.player pause];
    }
    
}
- (void)playerDidFinishPlaying:(NSNotification *)notification {
    // 视频播放结束后，调用stop方法清理资源
    [self stop];
}

// 这是非常重要的一步！当cell被重用时，必须停止播放并清理资源。
- (void)prepareForReuse {
    [super prepareForReuse];
    [self stop];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    // 确保playerLayer的frame始终与cell的bounds一致
    self.playerLayer.frame = self.playerView.bounds;
}

- (void)dealloc {
    
    // 移除所有通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
