# Independent API v1 example

This is a separate, optional test mod, not part of the main mod ZIP. It requires Ultimate Light Rail revision 44 or newer and adds one fixed surface through station with 80m platforms.

Its script imports the core API through the other mod namespace. Its own platform wrapper points at installed native meshes/materials, with exactly the reference dimensions. No native binary assets are included. The appearance intentionally matches the standard station so geometry can be compared directly.

The local integration test checks this consumer through a namespace-aware test loader. Actual two-mod loading, dependency activation and placement still require a game test. This is not proof that community add-ons already work in-game.
