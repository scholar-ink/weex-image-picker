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
/***/ (function(module, exports, __webpack_require__) {

	"use strict";

	var _src = __webpack_require__(4);

	var _src2 = _interopRequireDefault(_src);

	function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

	if (window.Weex) {
	  Weex.install(_src2.default);
	} else if (window.weex) {
	  weex.install(_src2.default);
	}

/***/ }),
/* 1 */,
/* 2 */,
/* 3 */,
/* 4 */
/***/ (function(module, exports) {

	'use strict';

	Object.defineProperty(exports, "__esModule", {
	  value: true
	});
	var imagePicker = {
	  show: function show() {
	    alert("module imagePicker is created sucessfully ");
	  }
	};

	var meta = {
	  imagePicker: [{
	    name: 'show',
	    args: []
	  }]
	};

	function init(weex) {
	  weex.registerModule('imagePicker', imagePicker, meta);
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