// web/static/js/views/page/new.js

import MainView from '../main';

export default class PagePostAddView extends MainView {
  mount() {
    super.mount();

    // Specific logic here
    console.log('PagePostAddView mounted');
  }

  unmount() {
    super.unmount();

    // Specific logic here
    console.log('PagePostAddView unmounted');
  }
}

