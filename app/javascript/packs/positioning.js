var options = {
  enableHighAccuracy: true,
  timeout: 5000,
  maximumAge: 0
};

function success(pos) {
  var crd = pos.coords;

  // console.log('Your current position is:');
  // console.log('Latitude : ' + crd.latitude);
  // console.log('Longitude: ' + crd.longitude);
  // console.log('More or less ' + crd.accuracy + ' meters.');

  var url = window.location.href;
  if (url.indexOf('?lat=') === -1) {
    document.location.href = "/meals?lat=" + crd.latitude + "&lng=" + crd.longitude;
  }

};

function error(err) {
  console.warn('ERROR(' + err.code + '): ' + err.message);
};

window.navigator.geolocation.getCurrentPosition(success, error, options);
