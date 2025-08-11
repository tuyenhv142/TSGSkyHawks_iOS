//
//  EGYoutubeView.h
//  QuickstartApp
//
//  Created by rick on 1/24/25.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>
#import <SDWebImage.h>
#import <GTLRYouTube.h>

NS_ASSUME_NONNULL_BEGIN

@interface EGYoutubeView : UIView

@property (nonatomic, strong) GTLRYouTubeService *service;
@property (nonatomic, strong) NSMutableArray *videos;
@property (nonatomic, strong) UIButton *moreBtn;

- (void)fetchYouTubeVideos;
@end

NS_ASSUME_NONNULL_END
