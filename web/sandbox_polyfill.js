// LLM Arcade mounts cabinets in sandbox="allow-scripts" (opaque origin).
// Chromium throws merely reading navigator.serviceWorker there, which Godot's
// optional PWA callback probes at boot. A harmless inert registration keeps
// the non-threaded cabinet free of a non-fatal sandbox SecurityError.
(function () {
  try {
    Object.defineProperty(Navigator.prototype, "serviceWorker", {
      configurable: true,
      get: function () {
        return {
          getRegistration: function () {
            return Promise.resolve(null);
          },
          register: function () {
            return Promise.resolve(null);
          },
        };
      },
    });
  } catch (_) {
    // Some hosts forbid redefining Navigator; Godot still runs.
  }
})();
