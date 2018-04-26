import GMaps from 'gmaps/gmaps.js';

const mapElement = document.getElementById('map');
if (mapElement) { // don't try to build a map if there's no div#map to inject in
  const map = new GMaps({ el: '#map', lat: 0, lng: 0 });
  const markers = JSON.parse(mapElement.dataset.markers);
  map.addMarkers(markers);
  if (markers.length === 0) {
    map.setZoom(2);
  } else if (markers.length === 2) {

    map.setCenter(markers[0].lat, markers[0].lng);
    map.setZoom(12);
  } else {
    map.fitLatLngBounds(markers);
  }
}

// import GMaps from 'gmaps/gmaps.js';

// const mapElement = document.getElementById('map');
// if (mapElement) { // don't try to build a map if there's no div#map to inject in
//   const map = new GMaps({ el: '#map', lat: 0, lng: 0 });
//   const markers = JSON.parse(mapElement.dataset.markers);

//   console.log(map);


//   for (var i = markers.length - 1; i >= 0; i--) {
//     var marker = markers[i];
//     var myLatLng = {lat: parseFloat(marker.lat), lng: parseFloat(marker.lng)};

//     var markerObject = new google.maps.Marker({
//       position: myLatLng,
//       map: map.map,
//       title: 'Hello World!'
//     });
//     markerObject.setIcon("http://maps.google.com/mapfiles/ms/icons/green-dot.png");
//   }

//   // map.addMarkers(markers);

//   if (markers.length === 0) {
//     map.setZoom(2);
//   } else {
//     map.fitLatLngBounds(markers);
//   }
// }
