var options = {
	enableHighAccuracy: true,
	timeout: 5000,
	maximumAge: 0
};

function success(pos) {
  // alert("lat: " + pos.coords.latitude + " lng: " + pos.coords.longitude);
  setCookie("lat", pos.coords.latitude);
  setCookie("lng", pos.coords.longitude);
  $(".navbar").show();
  $(".spinnerdiv").hide();
  console.log(pos.coords.latitude);
  console.log(pos.coords.longitude);

  //CLOSE POPUP
};

function error(err) {
console.warn('ERROR(' + err.code + '): ' + err.message);
 document.getElementById("positiontext").innerHTML = "Sorry, you can't use this app without enabling geolocation";
   $(".spinner").hide();
  $(".navbar").hide();


};

window.navigator.geolocation.getCurrentPosition(success, error, options);

//OPEN POPUP

function setCookie(name,value,days) {
	var expires = "";
	if (days) {
		var date = new Date();
		date.setTime(date.getTime() + (days*24*60*60*1000));
		expires = "; expires=" + date.toUTCString();
	}
	document.cookie = name + "=" + (value || "")  + expires + "; path=/";
}
