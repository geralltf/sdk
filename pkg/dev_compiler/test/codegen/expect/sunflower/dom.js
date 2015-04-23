var dom;
(function(exports) {
  'use strict';
  class JsName extends core.Object {
    JsName(opts) {
      let name = opts && 'name' in opts ? opts.name : null;
      this.name = name;
    }
  }
  class Overload extends core.Object {
    Overload() {
    }
  }
  let overload = dart.const(new Overload());
  let EventListener = dart.typedef('EventListener', () => dart.functionType(dart.void, [Event]));
  class Event extends core.Object {}
  let InputElement = HTMLInputElement;
  let CanvasElement = HTMLCanvasElement;
  class RenderingContext extends core.Object {}
  class CanvasDrawingStyles extends core.Object {
    CanvasDrawingStyles() {
      this.lineWidth = null;
      this.lineCap = null;
      this.lineJoin = null;
      this.miterLimit = null;
      this.lineDashOffset = null;
      this.font = null;
      this.textAlign = null;
      this.textBaseline = null;
    }
  }
  class CanvasPathMethods extends core.Object {}
  // Exports:
  exports.JsName = JsName;
  exports.Overload = Overload;
  exports.overload = overload;
  exports.EventListener = EventListener;
  exports.Event = Event;
  exports.InputElement = InputElement;
  exports.CanvasElement = CanvasElement;
  exports.RenderingContext = RenderingContext;
  exports.CanvasDrawingStyles = CanvasDrawingStyles;
  exports.CanvasPathMethods = CanvasPathMethods;
})(dom || (dom = window));
