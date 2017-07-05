// web/static/js/views/loader.js
// https://blog.diacode.com/page-specific-javascript-in-phoenix-framework-pt-1

import MainView    from './main';
import PostMapIndexView from './page/post_map';
import PostMapNewView from './page/post_map_new';

// Collection of specific view modules
const views = {
    PostMapIndexView,
    PostMapNewView,
};

export default function loadView(viewName) {
  console.log("Loading view: " + viewName);
  return views[viewName] || MainView;
}
