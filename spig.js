const { Spig } = require('spignite');

Spig.hello();

// PAGES

Spig
  .on('/**/*.{md,njk}')

  ._('META')
  .pageMeta()
  .summary()

  ._('INIT')
  .pageLinks()

  ._('RENDER')
  .render()
  .applyTemplate()
  .htmlMinify()
;


// ASSETS

Spig
  .on('/**/*.{png,jpg,gif,pdf}')

  ._('IMAGES')
  .assetLinks();


Spig.run();
