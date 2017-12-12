const imagePicker = {
  show() {
      alert("module imagePicker is created sucessfully ")
  }
};


const meta = {
    imagePicker: [{
    name: 'show',
    args: []
  }]
};

function init(weex) {
  weex.registerModule('imagePicker', imagePicker, meta);
}

export default {
  init:init
}

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

