import ImagePicker from "../../js/src";

if (window.Weex) {
  Weex.install(ImagePicker);
} else if (window.weex) {
  weex.install(ImagePicker);
}