// web/static/js/views/page/post_map_new.js
import MainView from '../main';
import L from "leaflet";
import "leaflet-draw";

export default class PagePostMapNewView extends MainView {
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

  // Marker for post locations
  var marker;

  // Map setup
  mymap.on('click', onMapClick);
  jQuery('#submit').on('click', submitPost);

  // Encryption controls
  jQuery('#is-encrypted').click(function(e) {
      jQuery('#pass-group').toggleClass('hide');
      jQuery('#pass-field').val('');
      jQuery('#pass-confirm').val('');
  });

  function onMapClick(e) {
    if (marker) {
      marker.remove();
    }
    jQuery("#lat").html(' ' + e.latlng.lat);
    jQuery("#lng").html(' ' + e.latlng.lng);
    marker = L.marker(e.latlng).addTo(mymap);
  }

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
    clearMessage('danger');
    var url = "/api/json_posts";
    var data = {
        'location': getLocation(),
        'message': getMessage(),
        'is_encrypted': getIsEncrypted(),
      }
      if ( data.is_encrypted ) {
          if ( passwordsMatch() ) {
              data.password = getPassword();
          }
          else {
              return showUnmatchedPasswordsMessage();
          }
      }
    data = JSON.stringify({'json_post': data});

    var settings = {
      'data': data,
      'contentType': 'application/json',
      'url': url,
      'success': function(res, status, obj) {
          clearPostForm();
          showMessage('Post added');
      }
    }

    jQuery.post(settings);

  }

  function getIsEncrypted() {
      return jQuery('#is-encrypted').is(':checked');
  }

  function getPassword() {
      return jQuery('#pass-field').val();
  }

  function passwordsMatch() {
      var pass = jQuery('#pass-field').val();
      var conf = jQuery('#pass-confirm').val();
      return ( pass != '' && pass == conf );
  }

  function showUnmatchedPasswordsMessage() {
      showMessage('Passwords must be non-empty and match', 'danger');
  }

  function showMessage(msg, type) {
      type = type || 'info';
      var selector = 'p.alert-' + type;
      jQuery(selector).html(msg);
  }

  function clearMessage(type) {
      var selector = 'p.alert-' + type;
      jQuery(selector).html('');
  }

  function clearPostForm() {
      clearMainForm();
      clearPassFields();
  }

  function clearPassFields() {
      jQuery('#pass-group').find('input').each(function(i, el) {this.value = ''});
  }


  function clearMainForm() {
      jQuery('#main-form').find('span').each(function(i) {this.text = ''});
      jQuery('#message').val('');
      jQuery('#is_encrypted').val('');
  }
}
}
