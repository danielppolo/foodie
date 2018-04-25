var options = {
  enableHighAccuracy: true,
  timeout: 5000,
  maximumAge: 0
};

function success(pos) {
  var crd = pos.coords;
  setCookie("lat", pos.coords.latitude);
  setCookie("lng", pos.coords.longitude);
  console.log("Cookie saved.");

  //CLOSE POPUP
};

function error(err) {
  console.warn('ERROR(' + err.code + '): ' + err.message);
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
