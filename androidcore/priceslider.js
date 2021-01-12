var currentPos;
var minCount;
var currentPostwo;
var maxCount;

check_disable (currentPos, currentPostwo);

if (currentPos>=0 && currentPostwo) {
	if (minCount>=0 && maxCount) {
					if (currentPos<minCount){currentPos=minCount;}
					if (currentPostwo>maxCount){currentPostwo=maxCount;}
					if (currentPos>maxCount){currentPos=maxCount;}
					if (currentPostwo<minCount){currentPostwo=minCount;}
					var rele=document.getElementById('rele');
					var reletwo=document.getElementById('reletwo');
					var line=document.getElementById('line');
					var inpmin=document.getElementById('minCurr');
					var inpmax=document.getElementById('maxCurr');
					var rightEdge = line.offsetWidth - rele.offsetWidth*2; 
					rele.style.left=((currentPos-minCount)*rightEdge)/Count+"px";
					reletwo.style.left=((currentPostwo-minCount)*rightEdge)/Count+"px";
					
					//rele.ontouchstart = function(f) {
					rele.addEventListener('touchstart', function(f) {
						if (f.cancelable) f.preventDefault();
						var shiftX = f.targetTouches[0].pageX - rele.offsetLeft;
						var maxavail = reletwo.offsetLeft-line.offsetLeft-reletwo.offsetWidth;
						//document.ontouchmove = function(f) {
						rele.addEventListener('touchmove', function(f) {
							var newLeft = f.targetTouches[0].pageX - shiftX - line.offsetLeft;
							if (newLeft < 0) {newLeft = 0;}
							if (newLeft > maxavail) {newLeft = maxavail;}
							if (newLeft > rightEdge) {newLeft = rightEdge;}
							rele.style.left = newLeft + 'px';
							inpmin.value=Math.round((newLeft/rightEdge)*Count)+minCount;
							
						})
						document.ontouchend = function() {document.ontouchmove = document.ontouchend = null;check_disable (inpmin.value, inpmax.value);};
						return false;
					});
									
					//reletwo.ontouchstart = function(e) {
					reletwo.addEventListener('touchstart', function(e) {
						if (e.cancelable) e.preventDefault();
						var shiftXtwo = e.targetTouches[0].pageX - reletwo.offsetLeft;
						var minavail = rele.offsetLeft - line.offsetLeft;
						//document.ontouchmove = function(e) {
						reletwo.addEventListener('touchmove', function(e) {
							var newLefttwo = e.targetTouches[0].pageX - shiftXtwo - line.offsetLeft;
							if (newLefttwo < 0) {newLefttwo = 0;}
							if (newLefttwo < minavail) {newLefttwo = minavail;}
							if (newLefttwo > rightEdge) {newLefttwo = rightEdge;}
							reletwo.style.left = newLefttwo + 'px';
							inpmax.value=Math.round((newLefttwo/rightEdge)*Count)+minCount;
						})
						document.ontouchend = function() {document.ontouchmove = document.ontouchend = null;check_disable (inpmin.value, inpmax.value);};
						return false;
					});
					
	}

}

function check_disable (mncurr, mxcurr){
	(mncurr==minCount) ? $("input#minCurr").prop('disabled', true) : $("input#minCurr").prop('disabled', false);
	(mxcurr==maxCount) ? $("input#maxCurr").prop('disabled', true) : $("input#maxCurr").prop('disabled', false);
};

