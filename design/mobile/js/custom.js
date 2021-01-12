// swipe check

function MobiSwipe(id) {
this.HORIZONTAL = 1;
this.VERTICAL = 2;
this.AXIS_THRESHOLD = 60; // ugol otkloneniya
this.GESTURE_DELTA = 30; // min sdvig for swipe
this.direction = this.HORIZONTAL;
this.element = document.getElementById(id);
this.onswiperight = null;
this.onswipeleft = null;
this.onswipeup = null;
this.onswipedown = null;
this.inGesture = false;
this._originalX = 0
this._originalY = 0
var _this = this;
this.element.onclick = function() {void(0)};
var mousedown = function(event) {
_this.inGesture = true;
_this._originalX = (event.touches) ? event.touches[0].pageX : event.pageX;
_this._originalY = (event.touches) ? event.touches[0].pageY : event.pageY;
// Only for iPhone
if (event.touches && event.touches.length!=1) {
_this.inGesture = false; // Cancel gesture on multiple touch
}
};
var mousemove = function(event) {

var delta = 0;
var currentX = (event.touches) ? event.touches[0].pageX : event.pageX;
var currentY = (event.touches) ? event.touches[0].pageY : event.pageY;

			subExSx = currentX-_this._originalX;
			subEySy = currentY-_this._originalY;
			powEX = Math.abs( subExSx << 2 );
			powEY = Math.abs( subEySy << 2 );
			touchHypotenuse = Math.sqrt( powEX + powEY );
			touchCathetus = Math.sqrt( powEY );
			touchSin = Math.asin( touchCathetus/touchHypotenuse );
			//if( (touchSin * 180 / Math.PI) < 45 ) {if (event.cancelable) event.preventDefault();}

if (_this.inGesture) {
if ((_this.direction==_this.HORIZONTAL)) {
delta = Math.abs(currentY-_this._originalY);
} else {
delta = Math.abs(currentX-_this._originalX);
}
if (delta >_this.AXIS_THRESHOLD) {
_this.inGesture = false;
}
}
if (_this.inGesture) {
if (_this.direction==_this.HORIZONTAL) {
delta = Math.abs(currentX-_this._originalX);
if (currentX>_this._originalX) {
direction = 0;
} else {
direction = 1;
}
} 
if (delta >= _this.GESTURE_DELTA) {
var handler = null;
switch(direction) {
case 0: handler = _this.onswiperight; break;
case 1: handler = _this.onswipeleft; break;
case 2: handler = _this.onswipedown; break;
case 3: handler = _this.onswipeup; break;
}
if (handler!=null) {
// Call to the callback with the optional delta
handler(delta);
}
_this.inGesture = false;
}
}
};
this.element.addEventListener('touchstart', mousedown, false);
this.element.addEventListener('touchmove', mousemove, false);
this.element.addEventListener('touchcancel', function() {
_this.inGesture = false;
}, false);
}
