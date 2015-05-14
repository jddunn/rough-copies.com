
function mouseDown() {
 	    document.getElementById("dreamCatcher").style.color = "#9C9C9C";
 	    document.body.style.background = "white";
 }

function mouseUp() {
 		document.body.style.background = "yellow";
		setTimeout(function(){document.body.style.background="white"},250);
 }

function myTimer() {
    var d = new Date();
    document.getElementById("demo").innerHTML = d.toLocaleTimeString();
}

}