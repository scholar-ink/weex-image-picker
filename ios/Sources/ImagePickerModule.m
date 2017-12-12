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
#import "AFHTTPSessionManager.h"

@interface ImagePickerModule()

@property (nonatomic, copy) WXModuleCallback onChooseCallBack;
@property (nonatomic, strong) NSMutableDictionary *options;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, assign) BOOL isOriginal;
@property (nonatomic, assign) NSString *sourceType;

@end

@implementation ImagePickerModule

WX_PlUGIN_EXPORT_MODULE(imagePicker, ImagePickerModule)
WX_EXPORT_METHOD(@selector(chooseImage:callback:))
WX_EXPORT_METHOD(@selector(previewImage:))
WX_EXPORT_METHOD(@selector(uploadFile:success:fail:progress:))

@synthesize weexInstance;

- (ZLPhotoActionSheet *)getActionSheet
{
    ZLPhotoActionSheet *actionSheet = [[ZLPhotoActionSheet alloc] init];
    
    actionSheet.configuration.languageType = 1;
    
    for (NSString *key in [self.options allKeys]) {
        
        if ([key isEqualToString:@"clipRatio"]) {
            actionSheet.configuration.clipRatios = @[GetClipRatio([self.options[key][@"x"] intValue], [self.options[key][@"y"] intValue])];
        } else if([key isEqualToString:@"sourceType"]){
            self.sourceType = self.options[key];
        }else{
            [actionSheet.configuration setValue:self.options[key] forKey:(key)];
        }
    }
    //如调用的方法无sender参数，则该参数必传
    actionSheet.sender = self.weexInstance.viewController;
    
    //记录上次选择的图片
    actionSheet.arrSelectedAssets = self.lastSelectAssets;
   
    return  actionSheet;
}

-(void)chooseImage:(NSDictionary *)options callback:(WXModuleCallback)callback
{
    NSMutableDictionary *mutableOptions = options.mutableCopy;

    NSArray *colorOptionArray = @[@"navBarColor",@"navTitleColor",@"bottomViewBgColor",@"bottomBtnsNormalTitleColor",@"bottomBtnsDisableBgColor"];
    for (NSString *key in [mutableOptions allKeys]) {

        if ([colorOptionArray containsObject:key]) {
            [mutableOptions setObject:[WXConvert UIColor:mutableOptions[key]] forKey:key];
        }
    }
    self.options = mutableOptions;
    
    ZLPhotoActionSheet *actionSheet = [self getActionSheet];

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
        
        [ZLPhotoManager anialysisAssets:assets original:isOriginal completion:^(NSArray<UIImage *> *images) {
            [hud hide];
            
            NSMutableArray *tempFiles = [NSMutableArray array];
            
            for (int i = 0; i < images.count; i++) {
                
                SDImageCache *manager = [SDImageCache sharedImageCache];
                
                NSString *tmpUrl = [NSString stringWithFormat:@"zcfile://tmp_%@.jpg", [[NSUUID UUID] UUIDString]];
                
                [manager storeImage:images[i] forKey:tmpUrl];
                
                NSMutableDictionary *tempFile = [NSMutableDictionary dictionary];
                
                [tempFile setObject:tmpUrl forKey:@"path"];
                
                [tempFiles addObject:tempFile];
            }
            callback(tempFiles);
        }];
    }];
    
    if ([self.sourceType isEqualToString:@"album"]) {
        actionSheet.configuration.allowTakePhotoInLibrary = false;
        [actionSheet showPhotoLibrary];
    } else if([self.sourceType isEqualToString:@"camera"]){
        actionSheet.configuration.allowTakePhotoInLibrary = true;
        [actionSheet showPreviewAnimated:YES];
    } else{
        actionSheet.configuration.allowTakePhotoInLibrary = false;
        [actionSheet showPreviewAnimated:YES];
    }
}

-(void)previewImage:(NSDictionary *)options
{
    NSArray *urls = options[@"urls"];
    
    if (urls != nil) {
        NSInteger index = [urls indexOfObject:options[@"current"]];
        
        NSMutableArray *arrNetImages = [NSMutableArray array];
        
        for (NSString *url in urls) {
            NSURL *nsurl = [NSURL URLWithString:url];
            [arrNetImages addObject:nsurl];
        }
        
        [[self getActionSheet] previewPhotos:arrNetImages index:index hideToolBar:YES complete:^(NSArray * _Nonnull photos) {
            NSLog(@"%@", photos);
        }];
    }
}

-(void)uploadFile:(NSDictionary *)options success:(WXModuleCallback)success fail:(WXModuleCallback)fail progress:(WXModuleKeepAliveCallback)progress
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:options[@"url"] parameters:options[@"formData"] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        SDImageCache *manager = [SDImageCache sharedImageCache];
        
        UIImage *imageFile = [manager imageFromDiskCacheForKey:options[@"filePath"]];
        
        NSData *data = UIImagePNGRepresentation(imageFile);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //上传
        [formData appendPartWithFileData:data name:options[@"name"] fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        //上传进度
        // @property int64_t totalUnitCount;     需要下载文件的总大小
        // @property int64_t completedUnitCount; 当前已经下载的大小
        //
        // 给Progress添加监听 KVO
        NSLog(@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        // 回到主队列刷新UI,用户自定义的进度条
        progress([NSString stringWithFormat:@"%f",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount],true);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
        NSLog(@"上传成功 %@", responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error.localizedDescription);
        NSLog(@"上传失败 %@", error);
    }];
}
@end
