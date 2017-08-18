import {Aurelia} from 'aurelia-framework'
import environment from './environment';

export async function configure(aurelia: Aurelia) {
  aurelia.use
    .standardConfiguration();

  if (environment.debug) {
    aurelia.use.developmentLogging();
  }

  if (environment.testing) {
    aurelia.use.plugin('aurelia-testing');
  }

  await aurelia.start();
  aurelia.setRoot();
}
