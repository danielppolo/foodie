function setCookie(name,value,days) {
	var expires = "";
	if (days) {
		var date = new Date();
		date.setTime(date.getTime() + (days*24*60*60*1000));
		expires = "; expires=" + date.toUTCString();
	}
	document.cookie = name + "=" + (value || "")  + expires + "; path=/";
}



if (navigator.geolocation) {
	navigator.geolocation.getCurrentPosition(
		function(position) {


			positionCords = {lat: position.coords.latitude, lng: position.coords.longitude};
			setCookie("lat", positionCords.lat);
			setCookie("lng", positionCords.lng);
			console.log(positionCords.lat);
			console.log(positionCords.lng);
			$(".navbar-wagon").show();
			$(".spinnerdiv").hide();
		},
		function(error) {
			console.warn('ERROR(' + error.code + '): ' + error.message);
			document.getElementById("positiontext").innerHTML = "Sorry, you can't use this app without enabling geolocation";
			$(".spinner").hide();
			$(".navbar-wagon").hide();
		},
		{timeout: 15000, enableHighAccuracy: true, maximumAge: 100000}
		);

}

// function success(pos) {
// 	setCookie("lat", pos.coords.latitude);
// 	setCookie("lng", pos.coords.longitude);
// 	console.log(pos.coords.latitude);
// 	console.log(pos.coords.longitude);
// 	$(".navbar-wagon").show();
// 	$(".spinnerdiv").hide();

//   //CLOSE POPUP
// };


// function error(err) {

// 	console.warn('ERROR(' + err.code + '): ' + err.message);
// 	document.getElementById("positiontext").innerHTML = "Sorry, you can't use this app without enabling geolocation";
// 	$(".spinner").hide();
// 	$(".navbar-wagon").hide();

// };





//OPEN POPUP


