//
//  ImagePickerModule.m
//  WeexPluginTemp
//
//  Created by  on 17/3/14.
//  Copyright © 2017年 . All rights reserved.
//

#import "ImagePickerModule.h"
#import <WeexPluginLoader/WeexPluginLoader.h>
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoManager.h"
#import "ZLProgressHUD.h"
#import "SDImageCache.h"

@interface ImagePickerModule()

@property(nonatomic,copy)WXModuleCallback onChooseCallBack;
@property(nonatomic,copy)NSMutableDictionary *options;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, assign) BOOL isOriginal;
@end

@implementation ImagePickerModule

WX_PlUGIN_EXPORT_MODULE(imagePicker, ImagePickerModule)
WX_EXPORT_METHOD(@selector(init:))
WX_EXPORT_METHOD(@selector(showPreview:))
WX_EXPORT_METHOD(@selector(showImage:))
WX_EXPORT_METHOD(@selector(previewImage:))
WX_EXPORT_METHOD(@selector(previewSelected:))
WX_EXPORT_METHOD(@selector(previewSelectedImage:))

@synthesize weexInstance;

-(void)init:(NSDictionary *)options
{
    NSMutableDictionary *mutableOptions = options.mutableCopy;
    
    NSArray *colorOptionArray = @[@"navBarColor",@"navTitleColor",@"bottomViewBgColor",@"bottomBtnsNormalTitleColor",@"bottomBtnsDisableBgColor"];
    
    for (NSString *key in [mutableOptions allKeys]) {
        
        if ([colorOptionArray containsObject:key]) {
            [mutableOptions setObject:[WXConvert UIColor:mutableOptions[key]] forKey:key];
        }
    }
    self.options = mutableOptions;
}

- (ZLPhotoActionSheet *)getActionSheet
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
    actionSheet.configuration.languageType = 1;
    
    for (NSString *key in [self.options allKeys]) {
        
        [actionSheet.configuration setValue:self.options[key] forKey:(key)];
    
    }
    //如调用的方法无sender参数，则该参数必传
    actionSheet.sender = self.weexInstance.viewController;
    
    //记录上次选择的图片
    actionSheet.arrSelectedAssets = self.lastSelectAssets;
    
    zl_weakify(self);
    [actionSheet setSelectImageBlock:^(NSArray<UIImage *> * _Nonnull images, NSArray<PHAsset *> * _Nonnull assets, BOOL isOriginal) {
        zl_strongify(weakSelf);
        strongSelf.isOriginal = isOriginal;
        strongSelf.lastSelectAssets = assets.mutableCopy;
        strongSelf.lastSelectPhotos = images.mutableCopy;
        NSLog(@"image:%@", images);
        
        //解析图片
        ZLProgressHUD *hud = [[ZLProgressHUD alloc] init];
        //该hud自动15s消失
        [hud show];
        
//        [ZLPhotoManager anialysisAssets:assets original:isOriginal completion:^(NSArray<UIImage *> *images) {
            [hud hide];
            
            NSMutableArray *tempFiles = [NSMutableArray array];
            
            for (int i = 0; i < images.count; i++) {
            
                [ZLPhotoManager requestVideoForAsset:assets[i] completion:^(AVPlayerItem *item, NSDictionary *info) {
                    NSLog(@"item:%@", item);
                    NSLog(@"info:%@", info);
                }];
                
                
                SDImageCache *manager = [SDImageCache sharedImageCache];
                
                NSString* tmpUrl = [NSString stringWithFormat:@"http://tmp/%@.jpeg", [[NSUUID UUID] UUIDString]];
                
                [manager storeImage:images[i] forKey:tmpUrl];
                
                NSMutableDictionary *tempFile = [NSMutableDictionary dictionary];
                
                [tempFile setObject:tmpUrl forKey:@"path"];

                [tempFiles addObject:tempFile];
            }
            strongSelf.onChooseCallBack(tempFiles);
//        }];
    }];
    
    return  actionSheet;
}

-(void)showPreview:(WXModuleCallback)callback
{
    ZLPhotoActionSheet *actionSheet = [self getActionSheet];
    
    self.onChooseCallBack = callback;

    [actionSheet showPreviewAnimated:YES];
}
-(void)showImage:(WXModuleCallback)callback
{
    ZLPhotoActionSheet *actionSheet = [self getActionSheet];
    
    self.onChooseCallBack = callback;
    
    [actionSheet showPhotoLibrary];
}
-(void)previewImage:(NSDictionary *)options
{
    NSArray *arrNetImages = @[[NSURL URLWithString:@"http://tmp/535D3022-B258-49AA-8056-AA070E69516F.jpeg"],
                              [NSURL URLWithString:@"http://220.170.49.102/2/h/x/j/q/hxjqpybjhxqdclfzzdlqzvpknvbhfe/hc.yinyuetai.com/4A774FD00E8C1F61B9A1E4A08D6BE757.flv"],
                              [NSURL URLWithString:@"http://pic.962.net/up/2013-11/20131111660842029339.jpg"],
                              [NSURL URLWithString:@"http://pic.962.net/up/2013-11/20131111660842034354.jpg"],
                              [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1504756336591&di=56a3c8866c95891cbb9c43f907b4f954&imgtype=0&src=http%3A%2F%2Ff5.topitme.com%2F5%2Fa0%2F42%2F111173677859242a05o.jpg"],
                              [NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1504756368444&di=7e1a2d1fc8aeea41220b1dc56dfc0012&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201605%2F10%2F20160510182555_KQ8FH.thumb.700_0.jpeg"]];
    
    [[self getActionSheet] previewPhotos:arrNetImages index:0 hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
        NSLog(@"%@", photos);
    }];
}
-(void)previewSelectedImage:(NSDictionary *)options
{
    [[self getActionSheet] previewPhotos:self.lastSelectPhotos index:0 hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
        NSLog(@"%@", photos);
    }];
}
-(void)previewSelected:(NSDictionary *)options
{
    [[self getActionSheet] previewSelectedPhotos:self.lastSelectPhotos assets:self.lastSelectAssets index:0 isOriginal:(YES)];
}

-(void)uploadFile:(NSDictionary *)options
{
    
}
@end
