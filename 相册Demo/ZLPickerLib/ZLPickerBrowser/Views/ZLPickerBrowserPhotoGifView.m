//
//  gifView.m
//  playGif
//
//  Created by 张磊 on 14-11-15.
//  Copyright (c) 2014年 com.zixue101.www. All rights reserved.
//

#import "ZLPickerBrowserPhotoGifView.h"
#import "SDWebImageDownloader.h"
#import "UIView+Extension.h"

@implementation ZLPickerBrowserPhotoGifView
- (id)initWithFrame:(CGRect)frame filePath:(NSString *)filePath
{
    self = [super initWithFrame:frame];
    if (self)
    {
        NSDictionary *gifLoopCount = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(__bridge NSString *)kCGImagePropertyGIFLoopCount];
        
        gifProperties = [NSDictionary dictionaryWithObject:gifLoopCount forKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
        
        gif = CGImageSourceCreateWithURL((__bridge CFURLRef)[NSURL URLWithString:filePath], (__bridge CFDictionaryRef)gifProperties);
        
        count =CGImageSourceGetCount(gif);
        
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(play) userInfo:nil repeats:YES];
        [timer fire];
    }
    return self;
}

/**
 *  播放gif图
 */
- (void)playGifWithURLString:(NSString *)urlString{
    NSDictionary *gifLoopCount = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(__bridge NSString *)kCGImagePropertyGIFLoopCount];
    
    gifProperties = [NSDictionary dictionaryWithObject:gifLoopCount forKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
    
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:urlString] options:SDWebImageDownloaderUseNSURLCache progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            gif = CGImageSourceCreateWithData((__bridge CFDataRef)data,(__bridge CFDictionaryRef)gifProperties);
            count =CGImageSourceGetCount(gif);
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(play) userInfo:nil repeats:YES];
            [timer fire];
            
            self.y = ( self.height - image.size.height ) * 0.5;
            self.x = ( self.width - image.size.width ) * 0.5;
            self.width = image.size.width;
            self.height = image.size.height;
        });
    }];
}

-(void)play
{
    index ++;
    index = index%count;
    CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (__bridge CFDictionaryRef)gifProperties);
    self.layer.contents = (__bridge id)ref;
    CFRelease(ref);
}

- (void)dealloc
{
    NSLog(@"dealloc");
    CFRelease(gif);
}

- (void)stopGif
{
    [timer invalidate];
    timer = nil;
}

@end
