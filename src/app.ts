import { RouterConfiguration, Router, ConfiguresRouter } from 'aurelia-router';

export class App implements ConfiguresRouter {
  
  public router: Router;

  public configureRouter(config: RouterConfiguration, router: Router) {
    config.title = 'Aurelia on Azure';
    config.options.pushState = true;
    config.options.root = '/';
    config.map([
      { route: ['', 'home'], name: 'home', moduleId: 'home', title: 'Home', nav: true },
      { route: 'about', name: 'about', moduleId: 'about', title: 'About', nav: true }
    ]);
    this.router = router;
  }
}
