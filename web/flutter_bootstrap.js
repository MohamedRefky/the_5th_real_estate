{{flutter_js}}
{{flutter_build_config}}

_flutter.loader.load({
  onEntrypointLoaded: async function(engineInitializer) {
    const appRunner = await engineInitializer.initializeEngine();
    await appRunner.runApp();

    // Ensure first frame has rendered before fading out splash
    requestAnimationFrame(function() {
      requestAnimationFrame(function() {
        if (typeof window.removeNativeSplash === 'function') {
          window.removeNativeSplash();
        }
      });
    });
  }
});
