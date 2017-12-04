// { "framework": "Vue" }

/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ (function(module, exports) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	var ImagePicker = {
	  show: function show() {
	    alert("module ImagePicker is created sucessfully ");
	  }
	};

	var meta = {
	  ImagePicker: [{
	    name: 'show',
	    args: []
	  }]
	};

	function init(weex) {
	  weex.registerModule('ImagePicker', imagePicker, meta);
	}

	exports.default = {
	  init: init

	  /**
	   * The `div` example of the way to register component.
	   */
	  // const _css = `
	  // body > .weex-div {
	  //   min-height: 100%;
	  // }
	  // `

	  // function getDiv (weex) {
	  //   const {
	  //     extractComponentStyle,
	  //     trimTextVNodes
	  //   } = weex

	  //   return {
	  //     name: 'weex-div',
	  //     render (createElement) {
	  //       return createElement('html:div', {
	  //         attrs: { 'weex-type': 'div' },
	  //         staticClass: 'weex-div weex-ct',
	  //         staticStyle: extractComponentStyle(this)
	  //       }, trimTextVNodes(this.$slots.default))
	  //     },
	  //     _css
	  //   }
	  // }

	  // export default {
	  //   init (weex) {
	  //     const div = getDiv(weex)
	  //     weex.registerComponent('div', div)
	  //     weex.registerComponent('container', div)
	  //   }
	  // }

	};

/***/ })
/******/ ]);