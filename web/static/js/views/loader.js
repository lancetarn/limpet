// web/static/js/views/loader.js

import MainView    from './main';
import PagePostAddView from './page/post_add';

// Collection of specific view modules
const views = {
    PagePostAddView,
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
