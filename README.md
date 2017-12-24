![image](https://github.com/scholar-ink/weex-image-picker/blob/master/效果图/image-picker.gif)

### image-picker
方便易用的相册多选框架,针对android、ios、web(后续新增)平台下的图片选择器，支持从相册或拍照选择图片，支持动态权限获取、裁剪(单图裁剪)、压缩等功能、适配android 6.0+，ios8+ 系统的开源图片选择框架。

支持的WeexSDK版本： >= 0.16.0

### <a id="功能介绍"></a>功能介绍
- [x] 支持横竖屏 (已适配iPhone X)
- [x] 预览快速选择
- [x] 直接进入相册选择
- [x] 相册内滑动多选
- [x] 裁剪图片(可自定义裁剪比例)
- [x] 在线下载iCloud照片
- [x] 预览网络及本地照片(支持长按保存至相册)
- [x] 动态获取系统权限，避免闪退
- [x] 支持裁剪比例设置，如常用的 1:1、3：4、3:2、16:9 默认为图片大小
- [x] 新增上传图片功能
- [x] 新增选择视频功能
- [ ] 新增选择视频，编辑视频功能
- [ ] 支持web端图片选择，上传


### 快速使用

  ```
  weex plugin add weex-plugin-image-picker
  ```
# 项目地址
[github](https://github.com/scholar-ink/weex-image-picker)

###使用方法

* 第一步：
##### iOS集成插件ImagePicker
- 命令行集成
  ```
  weex plugin add weex-plugin-image-picker
  ```
- 手动集成
  在podfile 中添加
  ```
  pod 'WeexImagePicker'
  ```

##### 安卓集成插件imagepicker
- 命令行集成
  ```
  weexpack plugin add weex-plugin-image-picker
  ```
- 手动集成
  在相应工程的build.gradle文件的dependencies中添加
  ```
  compile 'org.weex.plugin:imagepicker:{$version}'
  ``` 

##### 浏览器端集成 image-picker
- 命令行集成
  ```
  npm install  image-picker
  ```
- 手动集成
  在相应工程的package.json文件的dependencies中添加
  ```
  image-picker:{$version}'
  ``` 
第二步：

代码中调用
```javascript
chooseImage: function() { //选择图片
    let that = this;
    plugin.chooseImage({
        maxSelectCount: 10, //最大选择数 默认9张，最小 1
        allowSelectGif: true, //是否允许选择Gif，只是控制是否选择，并不控制是否显示，如果为NO，则不显示gif标识 默认true
//      sourceType: 'camera', //album 从相册选图，camera 使用相机，默认二者都有
        allowEditImage: true, //是否允许编辑图片，选择一张时候才允许编辑，默认true
        clipRatio:{
            x: 16,
            y: 9
        },
    },function (images) {

        let image_arr = [];

        for (let image of images){
            image_arr.push(image['path'])
        }

        that.images = image_arr;

        console.log(JSON.stringify(images));
    });
},
previewImage: function () { //预览图片
    plugin.previewImage({
        urls: [
            'http://pic.962.net/up/2013-11/20131111660842029339.jpg',
            'http://pic.962.net/up/2013-11/20131111660842034354.jpg'
        ],
        current: 'http://pic.962.net/up/2013-11/20131111660842034354.jpg',
    })
},
uploadFile: function () {  //上传图片
    plugin.uploadFile({
        url: 'https://up.qiniup.com',
        formData: {
            token:""
        },
        name: 'file',
        filePath:this.images[0]
    },function (successData) {
        console.log(successData)
    },function (err) {
        console.log(err)
    },function (process) {
        console.log(process)
    })
}
```
### Feature
  
  > 如果您在使用中有好的需求及建议，或者遇到什么bug，欢迎随时issue，我会及时的回复
  

### 框架支持
最低支持：iOS 8.0  android 6.0+

