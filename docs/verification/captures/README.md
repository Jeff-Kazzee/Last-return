# Visual captures

These 1280×720 PNGs come from the real Godot project rendered under isolated Xvfb with the Compatibility renderer. They are **visual evidence only**.

- `title.png`, `duel.png`, `breach.png`, `open-exit.png`, and `departure.png` were captured by `tests/capture_visual_states.gd`, which deliberately stages presentation states. Its score and opened-mechanism assignments are not gameplay proof.
- Behavioral evidence for scoring, return ownership, pause, target destruction, and exit completion comes from the separate input-only and mechanics runs recorded in `../verified-core-duel.md`.
- The visual capture run is not a performance measurement. LLVMpipe software rendering is slower than real time.
- Screenshots do not establish human readability, accessibility, fun, or Windows behavior.
