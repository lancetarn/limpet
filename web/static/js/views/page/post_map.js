// web/static/js/views/page/post_map.js
import MainView from '../main';
import L from "leaflet";
import "leaflet-draw";
import Handlebars from "handlebars";

export default class PagePostMapView extends MainView {
  mount() {
    super.mount();
    var h = new MapHandler();
    h.init();
  }

  unmount() {
    super.unmount();
  }
}

const MAPBOX_SRID = 3857;
class MapHandler {
  init() {
  // Web Mercator projection
  var mymap = L.map('map_container').setView([38.1496, -79.0717], 13);
  L.tileLayer('https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://mapbox.com">Mapbox</a>',
      maxZoom: 18,
      id: 'tarnation.l05oo3k5',
      accessToken: 'pk.eyJ1IjoidGFybmF0aW9uIiwiYSI6Ik9haXpZaEEifQ.oRViHAfpfGV1ejJ_Harqvg'
  }).addTo(mymap);

  // Add controls
  var drawnItems = new L.FeatureGroup();
  mymap.addLayer(drawnItems);
  var drawControlFull = new L.Control.Draw({
    edit: {
      featureGroup: drawnItems
    },
    draw: {
      polyline: false
    }
  });
  mymap.addControl(drawControlFull);

  var drawControlEditOnly = new L.Control.Draw({
      edit: {
          featureGroup: drawnItems
      },
      draw: false
  });

  var marker;


  function onMapClick(e) {
    if (marker) {
      marker.remove();
    }
    jQuery("#lat").html(e.latlng.lat);
    jQuery("#lng").html(e.latlng.lng);
    marker = L.marker(e.latlng).addTo(mymap);
  }

  function onCreatePolygon(e) {
    if (marker) {
      marker.remove();
    }
    drawnItems.addLayer(e.layer);
    var geojson = drawnItems.toGeoJSON();
    searchPosts(geojson);

    drawControlFull.remove(mymap);
    drawControlEditOnly.addTo(mymap)
  }

  mymap.on("draw:deleted", function(e) {
    drawControlEditOnly.remove(mymap);
    drawControlFull.addTo(mymap);
  });
  mymap.on('click', onMapClick);
  mymap.on(L.Draw.Event.CREATED, onCreatePolygon)
  jQuery('#submit').on('click', submitPost);

  function getLocation() {
    var lat = parseFloat(jQuery("#lat").html());
    var lng = parseFloat(jQuery("#lng").html());
    return {
      'type': 'Point',
      'coordinates': [lng, lat],
      'crs':{'type':'name','properties':{'name':MAPBOX_SRID}}
    };
  }

  function getMessage() {
    return jQuery('#message').val();
  }

  function submitPost() {
    var url = "/api/json_posts";
    var data = JSON.stringify({
      'json_post': {
        'location': getLocation(),
        'message': getMessage(),
      }
    });
    var settings = {
      'data': data,
      'contentType': 'application/json',
      'url': url,
      'success': function(res, status, obj) {
        console.log(res);
      }
    }

    jQuery.post(settings);

  }

  function searchPosts(geojson) {
    var url = '/api/area_posts';
    var geom = geojson.features[0].geometry;
    geom.crs = {"type": "name", "properties": {"name": MAPBOX_SRID}};
    var json = JSON.stringify(geom);
    var params = {'geojson': json};
    jQuery.get(url, params, function(res) {
      renderPosts({'posts': res.data});
    });
  }

  function renderPosts(posts) {
    var source   = jQuery('#posts-template').html();
    var template = Handlebars.compile(source);
    var html = template(posts);
    jQuery('#post_list').html(html);
  }
}
}
