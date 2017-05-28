// web/static/js/views/loader.js

import MainView    from './main';
import PostMapIndexView from './page/post_map';

// Collection of specific view modules
const views = {
    PostMapIndexView,
};

export default function loadView(viewName) {
  console.log("Loading view: " + viewName);
  return views[viewName] || MainView;
}
