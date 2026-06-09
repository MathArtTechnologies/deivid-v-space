### overall 
- allow to have 2 teams:
    - handle friendly fire, enable / disable state,  hits should register only if enabled or if the teams differ
    - two separate spawn / re-spawn zones
- improve lobby:
    - show a table of the connected peers 
    - allow for match to start only once everyone is ready
- spaceship movement:
    - tilt spaceship when turning, halo like, look at the video
- objective:
    - give the spacestation a life bar
    - determine win condition, multiple rounds? 
- respawn should have some timeout / penalty

### quality of life
- refactor component base architecture to use "the tick pattern", have only one physics_process per entity instead of one per component. This improves the predictability and readability of the code.
- refactor networking into network manage / available networks[] array, in preparation for noray and steam support

### unknowns, probably todo but unsure
- can the players restore health? how??
- ammunition, energy bar for the laser beam?


### other / long term
- noray support
- steam support