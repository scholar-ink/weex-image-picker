<template>
	<div class="conatiner">
		<im
		<text style="margin-bottom: 20px;">weex plugin examples</text>
		<div @click="showPreview" style="margin: 20px;padding:20px;background-color:#1ba1e2;color:#fff;"><text style="color:#fff">showPreview</text></div>
		<div @click="showImage" style="margin: 20px;padding:20px;background-color:#1ba1e2;color:#fff;"><text style="color:#fff">showImage</text></div>
		<div @click="previewImage" style="margin: 20px;padding:20px;background-color:#1ba1e2;color:#fff;"><text style="color:#fff">previewImage</text></div>
		<div @click="previewSelected" style="margin: 20px;padding:20px;background-color:#1ba1e2;color:#fff;"><text style="color:#fff">previewSelected</text></div>
		<div @click="previewSelectedImage" style="margin: 20px;padding:20px;background-color:#1ba1e2;color:#fff;"><text style="color:#fff">previewSelectedImage</text></div>
	</div>
</template>

<style>
	.container{
		flex: 1;
	}
</style>

<script>

	const plugin = weex.requireModule('imagePicker');

	module.exports = {
		data: {
			value: '',
			index: 0,
			txtChange: ''
		},
		created: function() {
			plugin.init({

				maxSelectCount: 10, //最大选择数 默认9张，最小 1
				maxPreviewCount: 20, //预览图最大显示数 默认20张
				allowSelectImage: true, //是否允许选择照片 默认true
				allowSelectVideo: true, //是否允许选择视频 默认true
				allowMixSelect: false, //是否允许混合选择，即可以同时选择image(image/gif/livephoto)、video类型， 默认true
				allowSelectGif: true, //是否允许选择Gif，只是控制是否选择，并不控制是否显示，如果为NO，则不显示gif标识 默认true
				allowTakePhotoInLibrary: false, //是否允许相册内部拍照 默认true
				allowEditImage: true, //是否允许编辑图片，选择一张时候才允许编辑，默认true
//				allowEditVideo: false, //是否允许编辑视频，选择一张时候才允许编辑，默认false
				allowSelectOriginal: true, //是否允许选择原图，默认true
//				clipRatios:[  //裁剪比例 默认 1:1 4:3 3:2 16:9
//					{
//						value1:1,
//						value2:1,
//					},
//					{
//						value1:4,
//						value2:3,
//					},
//					{
//						value1:3,
//						value2:2,
//					},
//					{
//						value1:16,
//						value2:9,
//					}
//				],
//              languageType: 1, //1.中文 2.中文繁体 3.英文 4.日文
//				maxVideoDuration: 120,//允许选择视频的最大时长，单位：秒， 默认 120s
//				allowRecordVideo: true, //是否允许录制视频，默认YES
//				maxRecordDuration: 10, //最大录制时长，默认 10s，最小为 1s
//				navBarColor: 'orange', //导航条颜色，默认 rgb(19, 153, 231)
//				navTitleColor: 'green', //导航标题颜色，默认 rgb(255, 255, 255)
//				bottomViewBgColor: '#FFFF00', //底部工具条底色，默认 rgb(255, 255, 255)
//				bottomBtnsNormalTitleColor: '#00FFFF', //底部工具栏按钮 可交互 状态标题颜色，底部 toolbar 按钮可交互状态title颜色均使用这个，确定按钮 可交互 的背景色为这个，默认rgb(80, 180, 234)
//				bottomBtnsDisableBgColor: '#000080', //底部工具栏按钮 不可交互 状态标题颜色，底部 toolbar 按钮不可交互状态颜色均使用这个，确定按钮 不可交互 的背景色为这个，默认rgb(200, 200, 200)
			})
		},
		methods: {
			showPreview: function() {

				plugin.showPreview(function (images) {
					console.log(images);
				});
			},
			showImage: function() {

				plugin.showImage(function (images) {
                    console.log(JSON.stringify(images));
                });
			},
			previewImage: function () {
				plugin.previewImage({

                })
			},
			previewSelected: function () {
				plugin.previewSelected({

				})
			},
			previewSelectedImage: function () {
				plugin.previewSelectedImage({

				})
			},
		}
	}
</script>