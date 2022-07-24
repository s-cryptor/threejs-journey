import * as THREE from 'three';

import Sizes from './Utils/Sizes';
import Time from './Utils/Time';
import Camera from './Camera';
import Renderer from './Renderer';
import World from './World/World';
import Resources from './Utils/Resources';
import sources from './sources';
import Debug from './Utils/Debug';

let instance = null;

export default class App {
  constructor(canvas) {
    if (instance) {
      return instance; // always return same instance of app
    }
    instance = this;

    //Global access
    window.app = this;
    this.canvas = canvas;

    /**
     * Setup
     */
    this.debug = new Debug();
    this.sizes = new Sizes();
    this.time = new Time();
    this.scene = new THREE.Scene();
    this.resources = new Resources(sources);
    this.camera = new Camera();
    this.renderer = new Renderer();
    this.world = new World();

    /**
     * Resizing event listener
     */
    this.sizes.on('resize', () => {
      this.resize();
    });

    /**
     * Tick event
     **/
    this.time.on('tick', () => {
      this.update();
    });
  }

  /**
   * Resize Function
   */
  resize() {
    this.camera.resize();
    this.renderer.resize();
  }

  /**
   * Updating function
   */
  update() {
    this.camera.update();
    this.world.update();
    this.renderer.update();
  }

  /**
   * Destroy function
   */
  destroy() {
    this.sizes.off('resize');
    this.time.off('tick');

    // Traversing the scene
    this.scene.traverse((child) => {
      console.log(child);
      if (child instanceof THREE.Mesh) {
        child.geometry.dispose();

        for (const key in child.material) {
          const value = child.material[key];
          if (value && typeof value.dispose === 'function') {
            value.dispose();
          }
        }
      }
    });

    this.camera.controls.dispose();
    this.renderer.instance.dispose();
    if (this.debug.active) {
      this.debug.ui.destroy();
    }
  }
}