package org.weex.plugin.imagepicker;

import android.app.Activity;
import android.content.Intent;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.weex.plugin.annotation.WeexModule;
import com.luck.picture.lib.PictureSelectionModel;
import com.luck.picture.lib.PictureSelector;
import com.luck.picture.lib.config.PictureConfig;
import com.luck.picture.lib.config.PictureMimeType;
import com.luck.picture.lib.entity.LocalMedia;
import com.taobao.weex.WXSDKEngine;
import com.taobao.weex.annotation.JSMethod;
import com.taobao.weex.bridge.JSCallback;
import com.taobao.weex.common.WXModule;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import io.github.lizhangqu.coreprogress.ProgressHelper;
import io.github.lizhangqu.coreprogress.ProgressUIListener;
import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.MultipartBody;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
import okhttp3.Response;

@WeexModule(name = "imagePicker")
public class ImagePickerModule extends WXModule {

    private JSCallback onChooseCallBack;
    
    //sync ret example
    //TODO: Auto-generated method example
    @JSMethod
    public String syncRet(String param) {
        return param;
    }

    //async ret example
    //TODO: Auto-generated method example
    @JSMethod
    public void asyncRet(String param, JSCallback callback) {
        callback.invoke(param);
    }


    @JSMethod
    public void chooseImage(HashMap<String,Object> options, JSCallback callback){

        this.onChooseCallBack = callback;

        PictureSelectionModel pictureSelectionModel;

        if (options.containsKey("sourceType")) {
            if ("album".equals(options.get("sourceType"))) {
                pictureSelectionModel = PictureSelector.create((Activity) this.mWXSDKInstance.getUIContext()).openGallery(PictureMimeType.ofImage()).isCamera(false);
            } else {
                pictureSelectionModel = PictureSelector.create((Activity) this.mWXSDKInstance.getUIContext()).openCamera(PictureMimeType.ofImage());
            }
        } else {
            pictureSelectionModel = PictureSelector.create( (Activity) this.mWXSDKInstance.getUIContext()).openGallery(PictureMimeType.ofImage());
        }

        for (Map.Entry<String, Object> entry : options.entrySet()) {

            switch (entry.getKey()) {
                case "maxSelectCount":
                    pictureSelectionModel.maxSelectNum(10);
                    break;
                case "allowSelectGif":
                    pictureSelectionModel.isGif((Boolean) entry.getValue());
                    break;
                case "sourceType":

                    if ("album".equals(entry.getValue())){
                        pictureSelectionModel.isCamera(false);
                    }

                    break;
                case "allowEditImage":
                    pictureSelectionModel.enableCrop((Boolean) entry.getValue());
                    break;
                case "clipRatio":

                    JSONObject ratio = (JSONObject) entry.getValue();

                    Integer x = ratio.getInteger("x");

                    Integer y = ratio.getInteger("y");

                    pictureSelectionModel.withAspectRatio(x,y);// 裁剪比例 如16:9 3:2 3:4 1:1 可自定义
            }
        }
        pictureSelectionModel.forResult(PictureConfig.CHOOSE_REQUEST);//结果回调onActivityResult code
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == -1) {
            switch (requestCode) {
                case PictureConfig.CHOOSE_REQUEST:
                    // 图片选择结果回调
                    List<LocalMedia> selectList = PictureSelector.obtainMultipleResult(data);

                    ArrayList<HashMap> list = new ArrayList<HashMap>();

                    // 例如 LocalMedia 里面返回三种path
                    // 1.media.getPath(); 为原图path
                    // 2.media.getCutPath();为裁剪后path，需判断media.isCut();是否为true
                    // 3.media.getCompressPath();为压缩后path，需判断media.isCompressed();是否为true
                    // 如果裁剪并压缩了，已取压缩路径为准，因为是先裁剪后压缩的
                    for (LocalMedia media : selectList) {

                        HashMap<String,Object> map = new HashMap<String,Object>();

                        byte[] path = media.getPath().getBytes();

                        map.put("path", "zcfile://tmp_" + Base64.encodeToString(path,Base64.DEFAULT));

                        list.add(map);
                    }

                    this.onChooseCallBack.invoke(list);
                    break;
            }
        }

    }

    @JSMethod
    public void previewImage(HashMap<String,Object> options){

        JSONArray urls = (JSONArray) options.get("urls");

        List<LocalMedia> medias = new ArrayList<>();

        for (int i = 0; i < urls.size(); i++) {

            String url = urls.getString(i);

            LocalMedia media = new LocalMedia(url, 0, false, 0, 0, PictureConfig.TYPE_IMAGE);

            media.setPictureType("image/jpeg");

            medias.add(media);
        }

        int position = urls.indexOf(options.get("current"));

        PictureSelector.create((Activity) this.mWXSDKInstance.getContext()).externalPicturePreview(position, medias);
    }

    @JSMethod
    public void uploadFile(HashMap<String,Object> options, final JSCallback success, final JSCallback fail, final JSCallback progress ){

        OkHttpClient mOkHttpClient = new OkHttpClient();

        MultipartBody.Builder builder = new MultipartBody.Builder();

        builder.setType(MultipartBody.FORM);

        String filePath = (String) options.get("filePath");

        filePath = filePath.replace("zcfile://tmp_","");

        filePath = new String(Base64.decode(filePath,Base64.DEFAULT));

        File file = new File(filePath);

        SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyyMMddhhmmss", Locale.CHINESE);

        String date = sDateFormat.format(new java.util.Date());

        builder.addFormDataPart("file",date + ".png", RequestBody.create(MediaType.parse("image/png"), file));

        JSONObject formData = (JSONObject) options.get("formData");

        for (String key:
        formData.keySet()) {

            builder.addFormDataPart(key,(String )formData.get(key));
        };

        MultipartBody body = builder.build();

        RequestBody requestBody = ProgressHelper.withProgress(body, new ProgressUIListener() {

            //if you don't need this method, don't override this methd. It isn't an abstract method, just an empty method.
            @Override
            public void onUIProgressStart(long totalBytes) {
                super.onUIProgressStart(totalBytes);
                Log.e("TAG", "onUIProgressStart:" + totalBytes);
            }

            @Override
            public void onUIProgressChanged(long numBytes, long totalBytes, float percent, float speed) {
                Log.e("TAG", "=============start===============");
                Log.e("TAG", "numBytes:" + numBytes);
                Log.e("TAG", "totalBytes:" + totalBytes);
                Log.e("TAG", "percent:" + percent);
                Log.e("TAG", "speed:" + speed);
                Log.e("TAG", "============= end ===============");

                progress.invokeAndKeepAlive((int) (100 * percent));
            }

            //if you don't need this method, don't override this methd. It isn't an abstract method, just an empty method.
            @Override
            public void onUIProgressFinish() {
                super.onUIProgressFinish();
                Log.e("TAG", "onUIProgressFinish:");
            }
        });

        Request request = new Request.Builder()
                .url((String) options.get("url"))
                .post(requestBody)
                .build();

        Call call = mOkHttpClient.newCall(request);

        call.enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {

                fail.invoke(e.getMessage());
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {

                success.invoke(JSONObject.parse(response.body().string()));

            }
        });

    }
}