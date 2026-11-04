# Last Return — Game Design Document

> Design version 0.1 · November 3, 2026 · Original authored document is the source of truth. This Markdown edition is a text extraction of that document; figures and complex tables are best viewed in the accompanying PDF/DOCX. Proposed mechanics/content counts are not verified implementations.

Last Return game design document
Arcade duels and an escape through a dreaming city
Prepared for Jeff Kazzee | November 3, 2026 | Version 0.1

Build a beautiful, demanding arcade game around returning dangerous projectiles. Use the same skill in
one-on-one courts, short action rooms, and a final fight against the operator of a dreaming city.
This document defines the proposed game, its full content target, the art pipeline, and a staged route to a
playable prototype. The recommended foundation is Godot, 2D gameplay, and curated AI-created art.


Figure 1 Last Station environmental concept. AI-generated key art establishes materials and atmosphere; it is not a
gameplay screenshot or a collision layout.

Full-game targets: eight districts, 64 authored campaign encounters, and 3,072 accepted optional trials.
First build: one court, one rival, and one connected combat room.

Design map
Read sections 1 to 7 for the game and story, 8 to 14 for progression and presentation, and 15 to 19 for
implementation and verification. All section titles are available in Word navigation.
1 Game direction
2 World and story
3 Core play and controls
4 Duels and action breaches
5 Campaign structure and pacing
6 Districts and bosses
7 The final confrontation
8 Equipment and power ups
9 Difficulty and rival behavior
10 Thousands of optional trials
11 Art direction and asset production
12 Sound and music
13 Interface and accessibility
14 Achievements and rewards
15 Engine and technical approach
16 Production milestones
17 Verification and release criteria
18 Example trial record
19 Art briefs and implementation handoff
20 Decisions for the next design review
21 Sources

1 Game direction
Last Return is a proposed arcade action game about escaping a dreaming city by turning its force against
it. We control a stranded courier carrying the Returner, a battered paddle that can redirect the city's
charged projectiles. Courts occupy stations, cinemas, factories, and residential ruins. Winning opens a
route through each district. Short fights between courts let us use the same returning skills against the
machinery that keeps people trapped.
The design centers on one-on-one duels, with compact run-and-gun breaches between them. The last
opponent eventually steps out of the tournament and fights us directly. We defeat that opponent with the
movement, aiming, and returning skills the campaign has taught.
The intended feeling is a hard-earned reversal: read a dangerous shot, intercept it, change its route, and
watch a seemingly secure opponent lose control. Beautiful environments give those exchanges a place
and a purpose. A victory changes the city in a visible, lasting way.

Product decisions
 Decision                          Proposed direction

 Genre                             2D arcade duels with short top-down action sequences

 Camera                            Fixed overhead gameplay camera with illustrated architectural depth

 First platform                    Windows desktop, playable offline

 Core audience                     Players who enjoy readable arcade skill, short retries, and strange worlds

 Campaign opponent                 AI rivals and authored bosses

 Human competition                 Local two-player versus after the solo core works

 Full campaign target              Eight districts and 64 authored encounters

 Extended challenge target         3,072 accepted optional trials

 Engine recommendation             Godot with GDScript and a 2D rendering pipeline

 Art direction                     Painted public infrastructure becoming impossible dream architecture

 First useful build                One court, one rival, one connected combat room


All counts, speeds, timing windows, durations, and performance budgets in this document are design
proposals. They need calibration through playable builds. Last Return is a working title whose availability
has not been checked. The full game is an ambition beyond the first release decision; no release date is
promised.

Principles that settle disagreements
1. A missed return must have a visible cause. Preserve the puck, paddle, goal, and hazard cues when
   decoration competes with them.
2. Each new mechanic must change a player's decision. A new texture alone does not establish a new
   level.
3. Movement and returning carry across modes. Introduce few new controls when leaving a court.
4. Clearing an encounter advances the story. Optional medals and trials reward mastery without blocking
   escape.

5. A district's architecture supports its rules. Gates, currents, shutters, and machinery should explain what
   the court does.
6. Develop content in small, complete batches. Expansion depends on measured production cost and
   playtest quality.

Position among nearby games
Projectile fighting already has strong precedents. Team Reptile describes Lethal League Blaze as a
projectile fighting game with high-speed exchanges and a story mode. Dotemu's Windjammers 2 combines
competitive disc play with special moves and hand-drawn animation. [S6, S7]
Our proposed identity comes from the courier's escape through a physically connected dream city, the
transfer of returning skills into action rooms, permanent environmental changes, and a final confrontation
that opens the court into the world. We should test those features as the game's own identity. We are not
claiming to have invented projectile combat.


2 World and story
The Interval
The Interval is a city caught between arrival and departure. Trains wait with their doors open. Cinemas
project weather onto empty screens. Apartment windows contain rooms that were never built. Every public
exit leads to a court, and every court promises that a winner may leave.
The city repeats these competitions because their returning energy keeps its buildings and inhabitants
intact. The Host operates the system and presents endless continuation as a kindness. People who keep
playing gradually become predictable: the same route, the same serve, the same mistake. The player
begins as a courier whose final delivery has no address.
We never need to settle whether the Interval is literally an afterlife, a dream, or an engineered prison. Its
local rules and consequences must still be clear. An unopened door becomes open after its power source
breaks. A freed resident can leave a district. A defeated rival remembers the defeat.

The courier and the Returner
The courier wears a bone-white work coat with a vermilion sleeve band. The silhouette must remain
recognizable at small scale. Their identity can be lightly specified so players can inhabit the role without a
long introduction.
The Returner resembles a repaired industrial paddle: ceramic striking face, brass rim, wrapped handle,
and a small charge indicator. It reflects the same energy that moves through the city's doors and courts. Its
active strike changes an incoming shot's direction. A separate low-powered sidearm helps clear small
mechanical enemies during breaches.
The courier's objective is concrete: reach the departure door and get out. Curiosity adds an optional
second objective: make routes usable for other residents along the way. We do not require completion of a
collection checklist to receive a real ending.

Supporting characters
   The Mender repairs Returners in quiet rooms between districts. This character introduces equipment
    changes and the art collection. Their room gradually fills with objects recovered from places we have
    freed.
   The Runner is a recurring rival who still believes the tournament's promise. Early encounters establish
    a recognizable playing habit. Later encounters let that habit change as the character learns the truth.

      The Witness leaves short route drawings in the margins of public notices. These drawings teach the
       existence of seams: vulnerable mechanisms outside the ordinary scoring route.
      The Host welcomes every challenger by name. Its attention feels personal until we notice it repeating
       the same sentences. Its visual form develops from a distant attendant into the operator of the final
       arena.
Dialogue is brief, optional on replay, and delivered outside active rallies. Environmental details carry much
of the story. A restored station clock starts moving; a silent cinema gains an audience of empty coats; an
apartment window finally opens onto daylight.

Story arc
The first two districts establish the rules and make winning feel like progress. Districts three through five
reveal that the city's promise perpetuates itself. The courier learns to redirect shots into marked
mechanisms beside the approved targets. Districts six and seven prepare a route that the Host cannot
close. The eighth district leads to the Host's last court and the departure door.
The main ending follows victory over the Host and a familiar aimed return into the departure mechanism.
Optional rescues change which residents appear along the final route and what we see in the epilogue.
These variations add meaning without revoking the player's escape. Continuing into trials afterward opens
a clearly labeled memory of the city, preserving the story's ending.


3 Core play and controls
Moment to moment
Read the incoming core, choose an interception point, move the Returner into position, and decide
whether to make a safe reflection or an aimed strike. Then recover toward the space the opponent can
exploit. Movement, shot placement, and commitment create the duel.
A basic return happens when the incoming core contacts the paddle. Pressing Strike in the contact window
allows a stronger directed return. Beginners can rally through positioning. Skilled players use timing,
banks, and softer placements to move their opponent before attacking the exposed goal.
We use one real scoring core in standard play. Special trials may add a second only after identification,
scoring, and simultaneous-contact rules are proven. The main campaign should build depth through
geometry and rival behavior before increasing the number of objects players must track.

Default controls
    Action       Keyboard and mouse     Controller          Behavior

    Move         WASD                   Left stick          Move within the legal part of the court or room

    Aim          Mouse position         Right stick         Face the Returner and choose the desired shot

    Strike       Left mouse             Right trigger       Perform an active return

    Fire         Right mouse            Left trigger        Fire the sidearm in breach rooms

    Dash         Space                  Left bumper         Make a short movement burst

    Technique    E                      Right bumper        Activate the equipped power-up

    Pause        Escape                 Menu                Pause solo play immediately

Fire is inactive in formal duels and never consumes a resource there. Its HUD slot visibly closes when
entering a court. Strike always means return; it never changes into a gun action. Controller facing holds the
last deliberate aim when the right stick returns to center. An optional assist can face the nearest incoming
returnable projectile.
All bindings are remappable. Provide keyboard-only aiming, adjustable stick dead zones, hold alternatives
where repeated tapping would otherwise be required, and an aim-assist setting. A movement-only return
preset can use the incoming projectile to determine facing. It must be named and explained in the settings.
Dash moves the courier quickly but does not grant general invulnerability. It cannot cross a court divider,
wall, goal boundary, or closed gate. This keeps an apparent collision from becoming secretly harmless. If
later testing supports invulnerability, treat that as an explicit redesign of every relevant enemy and hazard.

Core and collision contract
Passive paddle contact reflects according to the incoming path and the paddle's collision surface. An
active strike blends that legal rebound toward the aim direction within a bounded angle. It can add a small
amount of speed up to the encounter cap. Spin is a later addition that needs visible curvature and a
separate limit.
Court scoring comes only when the whole core crosses a goal plane through a valid opening. A wall-edge
graze is not a goal. The courier body is a physical obstacle: an unguarded body hit produces a weak,
unsteerable rebound and a brief visible shove. In a court it causes no health damage. In a breach the
same body hit removes one health and rebounds the projectile. Paddle contact prevents that damage.
These stakes are stated when the first breach begins.
Body rebounds earn no charge, receive no active-strike bonus, and cannot be mistaken for controlled
returns: use a dull impact and an abbreviated recoil. Keep the body collider smaller than the visible paddle
coverage. We should test whether repeated body blocking weakens goal defense; if it does, adjust court
and body dimensions before adding complex penalties.
Initial simulation proposal: a fixed 120 updates per second, with a 60 Hz alternative benchmarked on the
target laptop. Display rendering is separate. Use swept collision checks for the fastest core so it cannot
cross a thin rail between updates. A fixed timestep alone does not guarantee identical replays across
engines, machines, or builds.
Resolve one contact once. Preserve a minimum useful forward component after strikes. Bound speed,
angular change, and any later spin. Resolve the earliest actual swept contact; favor the paddle only on an
exact shared-boundary tie. A collision before the whole core crosses the goal plane can save it; a later
contact cannot reverse a score. An expired power-up must not change geometry while an object is
overlapping it.
When the core escapes valid bounds, becomes stationary, or enters a detected repeating trap, pause the
rally and visibly re-serve without awarding a point. Record the event for repair. A reset is recovery from a
fault, not a substitute for fixing a bad court.


4 Duels and action breaches
Standard duel rules
The default match is first to five goals, with no win-by-two requirement. Introductory matches can use first
to three. Target ordinary match duration is one to three minutes, subject to playtests. Boss objectives may
differ, but every change appears on the match introduction and in the pause menu.

Start each point with the core in a protected serve position and a visible countdown. The first server
alternates in local versus rematches; later serves go to the player who conceded. The serving player can
select from a limited aiming arc. If they do not act within the published serve window, the game serves
toward center. A serve cannot create an unavoidable immediate goal.
Both sides use the same basic movement limits and return rules. The courier remains within their marked
half. Opponents may have specific boss abilities, announced through visible preparation and the encounter
briefing. Court geometry changes between rallies unless a separately taught hazard explicitly moves
during play.
After a loss, Retry restarts that encounter with the same recipe, opening conditions, and chosen
equipment. During the campaign finale, Retry instead restores the current Host stage checkpoint, including
its recorded starting health, equipment, charge, and phase state. The optional continuous mastery trial
restarts the whole encounter. Retry does not replay an approach room or dialogue. Players can also
change equipment before restarting, practice the rule, adjust assistance, or leave to the district map. An
equipment change updates the selected loadout without carrying resources from a failed attempt. A
completed encounter commits progression before the result animation.

Four rulesets for the full game
 Ruleset                    Main challenge                            Scope

                            Defend a goal while creating a scoring
 Return court                                                         The core ruleset and first implementation
                            angle

                            Use walls or marked targets to expose a   Early expansion using the same movement and
 Bank court
                            scoring route                             core

                            Destroy a small set of barriers before    Later expansion after collision transitions are
 Break court
                            scoring                                   reliable

                            Work with a clearly marked bounce or
 Volley court                                                         Optional prototype after the core is proven
                            catch restriction


Ping-pong inspiration comes through placement, timing, controlled pace, and exchanges. A physically
simulated ball height, net, jumping smash, and full table-tennis rulebook would introduce another
substantial system. The first implementation stays on one gameplay plane. A volley variant can test
whether an explicit bounce token adds enough value before adding simulated height.

Breach rooms
Breach rooms last roughly 30 to 90 seconds and connect the courts physically. The courier runs through a
short route, shoots minor machinery, returns dangerous projectiles, and opens an exit. The camera stays
overhead. Rooms are authored and use the same projectile system as duels.
The courier starts each room with three health. Being hit removes one, followed by a short visible recovery
window that prevents one impact from causing repeated damage. A failed room restarts at its entrance. A
new room restores health; long-term healing inventory is unnecessary for this design.
The sidearm has unlimited low-powered shots and a bounded fire rate. It breaks small switches and light
enemies. Armored enemies expose weak points when their own projectiles return. The weapon earns its
place by helping the player create a safe returning position. We add it only after a deflection-only room
demonstrates the shared combat skill.

Enemy                      Recognizable behavior                        Player response

                            Charges a large round shot along a visible
 Signal sentry                                                           Return it into the exposed lens
                            line

                                                                         Reposition, use the sidearm, or return an isolated
 Sweep drone                Moves slowly and fires a narrow spread
                                                                         shot

                            Protects a door mechanism while              Bait its shot, circle, and hit the mechanism from a
 Lock carrier
                            approaching                                  safe angle

                                                                         Move out of the marked area; it cannot be
 Floor engine               Sends a hatched hazard across a lane
                                                                         returned


Round projectiles with a solid bright core are returnable. Floor waves and environmental danger use
distinct shapes, motion, and sound. The distinction cannot rely on red versus green. Avoid dense bullet
patterns until the central return and hazard vocabulary is established.
Each breach should contain one job: open a shutter, disable an anchor, rescue a resident, or reach an exit.
Long platforming routes, loot sorting, weapon rarity, and separate melee combos would consume the
production budget without testing the game's strongest idea.


5 Campaign structure and pacing
The full campaign contains eight districts with eight authored encounters each: five rival duels, two breach
rooms, and one boss. That produces 40 ordinary duels, 16 breaches, and eight boss encounters, for 64
total. The Host is the eighth boss. Its later phases remain part of that encounter.
A typical district begins with a clear example of its new mechanic. A breach then demonstrates the same
mechanism in the environment. Two duels explore it, a second breach adds story context, and two more
duels combine it with familiar skills. The boss tests those skills and visibly changes the district. We can
vary the ordering when the narrative benefits, while preserving the encounter budget.
Every cleared encounter unlocks the next main route. A refuge between districts provides equipment
selection, optional conversations, the art collection, practice, and the trial board. The map always
distinguishes the next story encounter from optional challenges.
Target a first escape of roughly four to six hours including exploration, dialogue, retries, and boss learning.
This is a pacing hypothesis. Measure actual encounter durations before using it in marketing. Provide a
meaningful session of five to fifteen minutes through checkpoints and short playlists.
Medals reward optional goals such as a bank score, a clean room, or a specific rival read. A clear always
advances the story. Currency, trial count, three-star ratings, and flawless runs never gate the main ending.
A player may replay any completed district and boss.
Each of the first seven districts contains one optional resident rescue inside an existing breach room. The
final district adds no collectible rescue requirement. The seven rescues form an explicit replayable set and
do not add mandatory encounters to the 64-encounter count.
The first ten minutes should establish movement, one safe return, one aimed shot, a short first-to-three
duel, a clearly signaled returning enemy, and the first glimpse of a larger opponent. Save before each
challenge. Introduce the full equipment screen only after the player has used one technique in a controlled
setting.

6 Districts and bosses
Each district introduces a mechanical idea, a distinct material palette, and one change after liberation.
Build its ordinary encounters around that idea before asking the boss to combine it with another. Bosses
use authored phases and bounded randomness; they do not emerge from the general trial generator.

 District               Visual identity                           New skill                           Boss

                        Ivory tile, petrol green, brass clocks,   Bank placement and readable
 1 Last Station                                                                                       The Conductor
                        platforms over a void                     openings

                        Submerged velvet seats, pale screen       Recognize real threats and
 2 Salt Cinema                                                                                        The Projectionist
                        light, drifting film                      change pace

                        Limestone counters, red seals,
 3 Mercy Exchange                                                 Open a goal through a switch shot   The Assessor
                        hanging balance weights

                        Charcoal trees, white leaves, ceramic     Shape a route through breakable
 4 Orchard of Ash                                                                                     The Keeper
                        fruit                                     cover

                        Transparent waterworks, drowned           Use a visible current to bend a
 5 Glass Reservoir                                                                                    The Diver
                        staircases, cobalt shadows                route

                        Organ pipes, cooling towers, orange       Read timing windows through
 6 Choir Foundry                                                                                      The Choir
                        furnace interiors                         sight and sound

                        Doorways in the sky, inhabited            Break a learned pattern and
 7 Unbuilt Suburb                                                                                     The Tenant
                        window fragments                          exploit a seam

                        Vast empty ticket hall, white daylight    Combine mastered returns and
 8 Exit Palace                                                                                        The Host
                        through black doors                       leave the court


The Conductor
A railway attendant with a dark mechanical signal for a head stands beyond the first court. Three goal
openings resemble train doors. One closes between points while the remaining routes stay clearly visible.
The Conductor moves early toward the obvious direct shot, leaving a bank route exposed.
The fight is first to five. After its second conceded goal, the Conductor begins using longer banks. After its
fourth, the open goal arrangement changes once more. The core never disappears behind a departing
train. Winning starts a single train and creates the first permanent route out of the district.

The Projectionist
A tall figure throws a pale silhouette across the flooded screen. Its special return produces a hollow visual
echo along the previous path. The real core remains solid and bright; the echo has no collision and cannot
score. Early duels already teach this visual distinction.
The Projectionist uses the echo to conceal its tactical preference, not the real object's identity. It moves
toward a familiar bank while the player can choose a soft direct shot. The fight is first to five; after the third
conceded goal, the boss alternates aggressive and defensive positions. Winning restores the screen to an
image of the next district and stills the surrounding water.

The Assessor
The Assessor occupies a counter suspended on enormous balance weights. Its goal is closed until the
core strikes a marked side bell. Hitting the bell opens a scoring window and leaves the boss deciding
whether to protect the direct route or the bank.
The fight requires three goals. The third window asks the player to use a different bell that was
demonstrated in an earlier duel. Missing a window safely resets the opportunity. A closed gate cannot trap
or crush the core. Winning tips the counters into a bridge and removes the city's first explicit demand for
further payment.

The Keeper
The Keeper tends an orchard of burnt trees bearing pale ceramic fruit. Three shallow root barriers offer
cover and banking surfaces. An active Strike breaks marked roots and opens a route; passive returns
rebound normally. Breaking roots requires no technique or charge expenditure, so the fight cannot require
a locked power-up.
The fight is first to five. Roots regrow only during point resets and never on the courier's spawn. The
Keeper protects newly opened lanes too aggressively, allowing the player to use an older route. Winning
gives one tree ordinary green leaves, a small color change reserved for this moment.

The Diver
The Diver moves behind glass channels. One central strip carries a visible current that pushes the core
laterally. Players can intercept before the strip or deliberately bank into its bend. Water texture, floating
particles, and an arrow-like carved channel all agree on the force direction.
The fight is first to five. The current changes direction between points. A later optional rematch can change
it during a rally with an explicit countdown and a tested safe response. Winning drains a staircase that had
been visible beneath the court throughout the chapter.

The Choir
The Choir is one opponent surrounded by suspended loudspeaker faces. Its goal shutters open in a
repeating sequence. A visible progress marker and mechanical movement communicate each window; the
soundtrack reinforces it.
The fight requires three goals. After each goal the sequence gains one previously taught variation. The
player can prepare a bank while the boss moves toward the direct lane. Audio timing alone never
determines success. Winning silences the industrial rhythm and introduces the first sustained birdsong in
the city.

The Tenant
The Tenant wears an unfinished version of the courier's coat. It remembers the last two deliberate shot
choices, then overcommits toward the repeated route. The player can teach it a pattern and break that
pattern with a soft placement or a different bank.
The fight is first to five. Between points, two residential walls move to fixed authored positions. In the last
phase, a seam mechanism outside the usual goal route becomes available. Hitting it opens a visible
recovery advantage and teaches the exact kind of choice needed in the finale. Winning assembles a real
doorway from the district's scattered frames.

7 The final confrontation
The Host's encounter has three stages, with a checkpoint at each stage boundary in the campaign. An
optional mastery trial can require a continuous clear. The pause menu always states the current objective.
The full encounter should last roughly five to eight minutes on a successful first clear; testing may change
that target.

Stage one The last court
The Host plays a first-to-three duel in a clean, almost empty hall. It combines the Conductor's opening
selection with the Tenant's readable prediction habit. It follows the same movement limits as other physical
opponents. Its advantage comes from switching plans, not from teleporting.
Each goal scored by the courier destroys one supporting machine. On the courier's third goal, the court's
rails detach and the camera reveals the floor beyond them. If the Host scores three first, the courier loses
and retries stage one. The player retains control after the transition. We avoid a long cinematic between
earning the break and acting on it.

Stage two The room becomes the court
The courier can move throughout the room and now has the three-health breach rules. The Host fires one
large charged core while three visible anchors maintain its protection. A returned core breaks an exposed
anchor; the sidearm cannot. Start this stage at full health. A retry restores the stage's starting state,
including its anchors. The default has no mid-stage health refill.
The Host opens one anchor at a time and telegraphs a floor sweep. The courier positions for the return
while avoiding the sweep. Only one anchor and one major core need attention at once. After three anchors
break, the Host steps onto the floor. The same action has moved from scoring into direct destruction.

Stage three The last return
The Host carries its own Returner. Stage three begins with three health on arrival and retry. Its checkpoint
records starting equipment and charge; a retry restores that state. The Host performs a short, readable
sequence: prepare a shot, launch, recover, and guard. During recovery, it folds the striking face aside and
exposes the device's housing. A returned core hitting this housing breaks one protection segment. When
the face returns to its guarded position, ordinary paddle reflection resumes. The two segments are
displayed physically, so progress is readable without a large health bar.
After two successful breaks, the departure seam opens beside the arena during every subsequent Host
recovery window. This symbol has appeared in the Mercy Exchange and Unbuilt Suburb. The Host tries to
reestablish the normal rally and protect itself. The player directs the Host's next core into the seam with an
ordinary aimed Strike, opens the departure door, and moves through it. No technique charge is required.
This finishing action uses an ordinary aimed return. No new quick-time input, unexplained target, or forced
equipment change appears in the finale. If the player continues targeting the Host, the fight remains
survivable and the Witness's route mark becomes more explicit. A missed seam shot closes the opening
until the next recovery window; broken protection segments remain broken for the current attempt. The
Host repeats its readable sequence until the courier escapes or loses. Retrying restores the stage-three
starting state without replaying earlier stages.
The Host's fall is visible in the environment: the courts lose their imposed boundaries, the waiting residents
can move, and daylight gains a direction. The epilogue reflects optional rescues. The game credits the
escape as complete before offering trials or a harder rematch.

8 Equipment and power ups
Equip one active technique and one passive relic before an encounter. Techniques are unlocked at
guaranteed campaign milestones. The first mandatory demonstration temporarily provides its required
technique. A story encounter never demands an optional trial reward.
Return charge runs from zero to 100. Proposed initial gain is ten for a passive paddle return and fifteen for
an active strike, with the higher value replacing the lower. Charge persists across points within a match
and resets on entering a new encounter. Each fresh enemy launch, opposing serve, or legal opposing
paddle return makes the projectile eligible to award charge once to the receiving player. That player's next
legal paddle contact consumes the eligibility. Walls, body rebounds, that player's subsequent strikes,
sidearm shots, and autonomous deflectors do not renew it. A continuing duel can award charge again after
another legal opposing paddle return. Stable projectile and attack IDs preserve this state across
reflections.
An active technique costs 100 charge. Most prepare an effect on the next legal contact. Only one prepared
effect may exist. Its marker remains visible until used or the rally ends. Refund only a next-contact
preparation that never triggered when the point resets. A timed effect or placed object counts as used
when it activates or appears, even if it never touches the core. Refunds cannot raise charge above 100.
Exact costs and durations remain tuning decisions to test together.

 Technique                  Effect                                      Limit and tactical cost

                            Hold the next core briefly, then release    Short hold timer; opponent can reposition; one
 Catch
                            toward the aim                              capture per activation

                            Improve the next controlled bank and make
 Bank mark                                                              Requires a wall route; no effect on a direct shot
                            its impact route clear

                            Extend the visible paddle for a short       Does not enlarge the body or create a permanent
 Long reach
                            interval                                    shield

                            Slow the core on the next legal paddle
 Brake                                                                  Grants recovery time to both players
                            contact

                            Place one temporary deflector at the dash
 Afterimage                                                             One contact, short lifetime, no charge generation
                            origin

                            Place a one-hit barrier just before the     It must contact the core before a legal goal; the
 Gate shield
                            player's goal plane                         rebound remains playable

                            Break one marked temporary barrier on the   Cannot pass through ordinary walls, goal rules, or
 Pierce
                            next return                                 the opponent

                                                                        Requires advance placement; fails safely if the
 Recall                     Return to a placed legal position marker
                                                                        destination becomes occupied


The first slice includes Catch and Brake only. Afterimage, Gate shield, and Recall require extra tests for
overlapping collision, goal order, and recovery. Multiball and invisible projectiles stay outside the initial
power-up pool.
Relics are modest sidegrades with explicit trade-offs. Heavy rim improves passive rebound stability while
reducing dash distance. Light grip shortens strike recovery while narrowing active reach. Patient coil
gains slightly more charge from a long exchange while offering none from the first return. Survey glass
makes one bank prediction easier to read while occupying the only relic slot. Tune values after their effects
are understandable.

Defeating bosses adds equipment options and cosmetic mementos. Optional medals unlock coat variants,
paddle finishes, court ornaments, and concept-art plates. We avoid permanent increases in paddle size or
damage that make old skill challenges meaningless. Local versus gives both players the same selectable
equipment regardless of campaign progress.


9 Difficulty and rival behavior
Campaign difficulty has four selectable presets: Story, Arcade, Expert, and Nightmare. A player can
change preset between encounters without losing story progress. Nightmare unlocks after a clear and
contains authored combinations; it should not depend on unreadable speeds.

 Preset                     Intended experience                        Primary changes

                                                                       Slower core, wider windows, fewer simultaneous
 Story                      Explore the city while learning returns
                                                                       demands

                            Learn a rival and win through deliberate
 Arcade                                                                Baseline speed and physical opponent limits
                            placement

                                                                       Better prediction, stronger positioning, more tested
 Expert                     Exploit openings consistently
                                                                       combinations

                                                                       Demanding authored scenarios within readable
 Nightmare                  Optional mastery of the full rules
                                                                       speed limits


These labels do not establish calibrated difficulty. Record player experience and perceived fairness when
testing. Difficulty belongs to several controls: observation delay, acceleration, prediction depth, placement
error, risk appetite, recovery opportunity, core speed, and number of active rules.
The AI observes the same visible state the player can observe, delayed according to its profile. It never
reads future inputs, hidden random outcomes, or the player's next uncommitted action. Both sides obey
court boundaries, collision shapes, and acceleration limits. Seeded mistakes resemble late commitment or
a poor tactical choice; constant random jitter is not convincing difficulty.

 Rival                      Habit the player can recognize             Effective response

 Keeper                     Guards the central route                   Stretch its coverage with banks

 Rusher                     Attacks far from its goal                  Place a return behind its commitment

 Banker                     Prefers a wall route                       Cover the second collision

 Counterpuncher             Waits for a hard attack                    Change pace with a soft placement

 Flanker                    Moves wide to create an aggressive bank    Attack the central space it leaves

 Mimic                      Repeats a recent tactic imperfectly        Establish a pattern and then change it


Offer assistance after repeated losses through a dismissible option. Assistance can widen the strike
window, reduce game speed, improve facing, or show a short incoming trajectory. Never silently change
the opponent during a fixed trial. Comfort settings such as camera motion, flashes, audio, and text size do
not change score categories. Gameplay assists may label a personal record's ruleset while preserving
progression and general achievements.

10 Thousands of optional trials
The full catalog target is 3,072 accepted trial encounters. The allocation is eight districts, six court
templates per district, eight tactical briefs per template, and eight materially different scenario
arrangements per brief. Multiplication gives 8 x 6 x 8 x 8 = 3,072. This is a production allocation subject to
validation, not proof that every combination is good.
Each trial is a published encounter specification with a stable ID and revision. Difficulty presets, seeds,
lighting changes, mirrored art, and opponent names do not count as additional trials. An arrangement must
change useful placement, route timing, a goal-opening sequence, or the opponent's tactical demand.

 Tactical brief                    Decision it emphasizes

 Open angles                       Choose placement against a readable rival

 Bank play                         Create a return route through usable walls

 Gate timing                       Send a shot through an available opening

 Breakable cover                   Decide when to reshape the court

 Switch opening                    Expose a goal before committing to the attack

 Hazard routing                    Place shots while preserving a safe response

 Interception distance             Choose an early interception or a deeper defensive position

 Sustained pressure                Maintain an advantage over several returns


A template that cannot support a brief is rejected. It receives another compatible arrangement or leaves
the catalog below target until suitable content exists. Publish the accepted count. Do not advertise an
unreviewed cross-product as thousands of handcrafted maps.

Recipe constraints
A trial combines a district kit, court topology, tactical brief, rival policy, hazard schedule, allowed power-up
pool, difficulty profile, and fixed scenario seed. Components declare requirements, incompatibilities, spatial
needs, timing needs, and supported difficulty bands.
Initially allow at most one geometry-changing feature, one environmental hazard, and one scoring modifier.
Introductory trials use fewer. Power-ups contribute to the same complexity budget. Boss phases use their
own authored specifications.
Reject an absorbing-wall court for a bank-only objective. Reject a switch objective without a reachable
switch. Reject a gate schedule whose open window cannot admit the intended shot. Avoid a power-up that
removes a surface required by the objective. A geometry change may not materialize a wall on the courier
or core.

Discovery and repeat play
Clearing a district opens its trial board. Present a small suggested set, with filters for mechanic, difficulty,
duration, completion, and favorite. Curated playlists provide useful sessions such as Learn bank shots,
Five minute run, and Hard rematches. Avoid presenting a wall of 3,072 empty checkboxes as the primary
interface.

A trial preview states the opponent, scoring rule, special mechanic, estimated difficulty, and equipment
restrictions. Retry preserves the exact recipe. Shareable codes contain the trial ID and content revision; a
seed by itself is insufficient. The campaign ending never requires a trial completion percentage.

Admission to the catalog
Every candidate must pass reference and bounds checks, spawn checks, reachable scoring-route checks,
hazard timing checks, bounded-speed simulation, and match-completion checks. Bots can expose
deadlocks and faults. They do not establish that humans will enjoy the result.
Human review covers every new mechanic family, boss, and combination category, plus a risk-weighted
sample of arrangements. Unusual loss rates, repeated resets, or complaints send a trial back for
inspection. Track the exact build and content hashes used for validation. Retire broken revisions without
erasing a player's existing completion.
Build a pilot of 12 accepted trials before expanding. A useful next step is 96 accepted trials across several
templates. Proceed toward the full target only when the production and review process can support it.


11 Art direction and asset production
Art is a main reason to enter the next district. The city should be beautiful enough that players want to stop
in a refuge and look. During a rally, it must leave enough visual space to read the next return. We achieve
both by placing the richest architectural detail beyond the active court and giving playable objects a
separate contrast language.
Use painted surfaces, deliberate silhouettes, stained materials, and improbable architecture. Favor worn
civic places over a general collection of demons and fire. Empty ticket halls, abandoned theaters, roots
inside factories, and windows over a void can carry the feeling of hell and purgatory through their function.


Figure 2 Salt Cinema gameplay-view concept. The court occupies a quiet central floor, with elaborate scenery outside the
active route. This is an AI-generated design illustration, not a running build.

Visual rules
The courier's bone-white coat and vermilion sleeve establish identity. The real core uses a solid ivory
center with a restrained dark outline where needed. Decorative lights stay below its local contrast. Goals
show their state through an opening shape and a mechanical movement as well as color.
Reserve soot, petrol green, stained ivory, rust, brass, and restrained amber for the station. Other districts
change material and dominant color while retaining the same core, warning, and interface language. Color
grades must never recolor a harmless background reflection into something that resembles the real core.
Keep the gameplay camera fixed during ordinary rallies. Avoid depth changes that distort trajectory
reading. Background perspective is illustration; all gameplay collision stays on one flat plane. Put fog, film
scraps, rain, and parallax outside the central flight route. Use optional camera motion only between
encounters.
An impact can use a brief sprite deformation, a short trail change, and a specific sound. Full-screen white
flashes, repetitive flicker, mandatory shake, and sustained bloom are excluded from the baseline
treatment. A high-contrast playfield option reduces decorative detail while retaining essential hazard
shapes.

What AI creates
Use AI image generation for environmental concepts, approved background plates, prop exploration,
character turnarounds, boss shape exploration, texture ideas, and art rewards. Generate during
development, then ship curated assets with the game. The player needs no cloud model, account, or
network connection to see them.
The process still needs art direction, selection, paintover, masking, animation, and integration. A concept
illustration does not provide clean layers, consistent poses, collision geometry, or a usable sprite sheet by
itself. Generated text is excluded from production signage and UI; add real editable typography separately.

Production sequence
1. Establish one approved district key image, one gameplay view, a palette, material references, and a
   silhouette sheet.
2. Define asset dimensions, camera, light direction, scale, ground contact, and separation into background,
   architecture, playfield, foreground, and effects.
3. Generate variations against the approved references. Change one material or composition variable at a
   time.
4. Select a small set. Correct unwanted details, inconsistent geometry, confusing highlights, and character
   drift.
5. Separate layers and export transparent props where appropriate. Create collision shapes in the engine
   independently.
6. Animate characters from approved turnaround and pose references. Use a manageable rig or carefully
   corrected frame set; never assume independently generated frames will stay consistent.
7. Review assets in the actual game camera at target scale, moving core speeds, reduced effects, and low
   graphics settings.
8. Record provenance and approve the asset before including it in a build. Keep the original, edited source,
   and game export associated.

First district asset budget
These are proposed production units. A layered kit may contain several files, so this table is not a literal file
count.

Asset group                Slice allocation                                Acceptance requirement

                            One layered station kit and one quiet
 Environment                                                                Supports three distinct court arrangements
                            refuge

 Courts                     Three layouts sharing a coherent kit            Clear goals, banks, and navigable floor

 Courier                    One directional character set or rig            Idle, move, strike, dash, hurt, and exit readable

                            Three readable variants from a shared
 Rivals                                                                     Distinct silhouettes and attack preparation
                            base

 Boss                       One Conductor set with phase changes            Telegraphs match active collision and rules

                            A small reusable set of rails, clocks, doors,
 Props                                                                      No repeated prop resembles the core
                            signs, and machinery

                            Return, body hit, goal, charge, danger,
 Effects                                                                    Legible with low effects and sound muted
                            break, and transition

 Interface                  One coherent HUD and a small icon set           Real text, clear focus, readable at 720p

 Rewards                    A few art plates and cosmetic variations        Consistent with the approved district style


Plan gameplay at a 1920 x 1080 reference resolution with scaling tests at 1280 x 720. Background
masters can be larger, but imported textures should match actual use. Crop sprites tightly and define
consistent pivots. Load the current district's large art rather than keeping the entire game resident.
Measure memory and transparent-layer overdraw before increasing texture size.
For each asset, retain an ID, category, creator or service, model version when available, prompt, source
references, generation date, source permissions, edits, dimensions, pivot, intended animation, license
notes, approval status, and export hash. This record supports revisions and store disclosures; it does not
establish a blanket ownership guarantee for generated content.
If we publish on Steam, its current Content Survey asks about player-facing content made with AI during
development and distinguishes it from content generated while the game runs. The intended pipeline falls
into pre-generated content when AI-created assets ship. Recheck the survey at submission and describe
the actual process. [S11]


12 Sound and music
The sound of a return should tell us what happened. Passive contact uses a compact ceramic tap. An
active strike adds a sharper rim tone. A body collision is dull and interrupted. A goal has a clear
mechanical release. The real core's sound stays distinct from the Projectionist's harmless echo.
Give each district a small musical vocabulary: distant rail pulses, damaged cinema strings, clattering
counterweights, dry leaves, submerged metal, factory voices, domestic room tones, and finally open air.
Arrange shared motifs into exploration, rally, pressure, and victory layers. Bring layers in at controlled
transitions so music does not obscure a warning.
Critical cues always have visual equivalents. Provide separate music, effects, ambience, dialogue, and
interface levels, plus a reduced-dynamic-range setting. Subtitle narrative speech and label meaningful
nonverbal cues. Keep voices optional for production; concise text and strong sound design can carry the
early build.

Sound assets need the same provenance and approval discipline as images. AI-generated audio, if used,
requires coherent editing and rights review before shipping. Do not clone a recognizable person's voice as
a shortcut to a character performance.


13 Interface and accessibility
The title screen prioritizes Continue, New escape, Trials, Local versus, and Settings. Show the saved
district and next encounter beside Continue. A second profile or an explicit confirmation protects an
existing campaign when starting over. Core solo play remains available offline.

 Screen or state            Main action                            Required feedback and recovery

 First launch               Set controls and comfort options       Test input, skip explanation, return to settings later

 District map               Continue the escape                    Clear next encounter and separate optional trials

                                                                   Opponent, rule, objective, equipment, and practice
 Encounter preview          Begin
                                                                   option

                                                                   Score, core, legal area, charge, and current
 Active duel                Return and defend
                                                                   hazard

                                                                   Health, returnable threats, objective, and sidearm
 Active breach              Reach the room exit
                                                                   status

 Pause                      Resume                                 Remap, adjust assistance, restart, or leave safely

                                                                   Save status, earned rewards, and readable loss
 Result                     Continue or retry
                                                                   cause

 Trial browser              Play a selected trial                  Filters, recipe revision, favorite, and replay

 Controller lost            Reconnect or select another input      Pause solo simulation and preserve the encounter

                                                                   Explain the failure without claiming progress was
 Save error                 Retry saving or preserve the session
                                                                   stored


The HUD occupies stable edges outside the core's route. Show score as plain numerals, health as distinct
shapes, charge as a labeled meter, and the equipped technique with its readiness. Hide inactive elements
when they have no role. Do not animate large notices across a live rally.
All menus need keyboard and controller navigation, visible focus, remappable controls, readable text
scaling, and plain descriptions of unusual rules. Pair color with shapes and labels. Support reduced
motion, optional trails, no shake, subdued flashes, contrast adjustments, and separate aim assists.
Comfort settings must be available before the opening scene.
Text and menu accessibility need practical evaluation with the selected engine and assistive tools. We
should not claim full screen-reader access to fast visual combat without designing and testing an
alternative representation. Provide clear menu semantics and an accessibility statement describing
supported behavior once it is verified.
Pause stops solo timers, effects with gameplay consequences, and AI. Losing application focus or a
controller pauses safely. Resume with a visible countdown that can be skipped by explicit input. Optional
art viewing never advances combat or consumes a timed reward.
At safe transitions, save campaign position, equipment, completed trials, medals, achievements, settings,
and content versions. Retry returns to the encounter start, except for the campaign Host fight, where it
restores the current stage checkpoint. Persist those stage checkpoints across quitting. Quitting mid-rally

resumes from the most recent committed encounter or stage start according to the shown save message;
exact mid-frame suspension is outside the initial requirement.


14 Achievements and rewards
Target 24 achievements for the full campaign, then revise the number if the events do not justify it. The
table proposes the first 16. Remaining entries should follow observed interesting play, not fill a quota.
Evaluate achievements from explicit gameplay events and stable IDs so retries or updates cannot
duplicate rewards.

 Achievement                       Unlock condition

 First departure                   Defeat the Conductor

 Borrowed force                    Destroy an armored sentry with its own returned shot

                                   Score after two legal wall hits since your most recent return, with no opposing paddle
 Two walls
                                   contact

 Hold your nerve                   Win a standard duel after trailing by three goals

 Open the window                   Score while a switch-opened goal is available

 A different route                 Defeat the Tenant after scoring both a direct goal and a wall-bank goal in that fight

 Last ticket                       Clear all eight district bosses

 Out                               Complete the escape ending

 A room for someone                Free the first optional resident

 All the way home                  Rescue the optional resident in each of the first seven districts

 Quiet hands                       Win the first ordinary Last Station duel without using dash

 Leave a mark                      Score from your Afterimage rebound before any subsequent paddle contact

 Turn the current                  Score using a bank that crosses the reservoir current

 Right on time                     Score during three distinct Choir opening patterns

 No anchors                        Break all three Host anchors with returned attacks

 Local legend                      Complete one local versus match with a second human player


General and story achievements remain available with assistance. Explicit mastery records state their
required rules and can live in a separate in-game medal system. Comfort settings do not invalidate them.
Avoid achievements that demand thousands of repetitive clears, random rare drops, long uninterrupted
sessions, or permanently missable actions.
Rewards include visible changes to a refuge, an art gallery, repaired objects, cosmetic equipment, and
optional challenge playlists. The gallery credits the creation and editing process. Viewing art and listening
to unlocked music should be available without starting a match.

15 Engine and technical approach
Use Godot with GDScript as the default. Godot provides a dedicated 2D workflow, reusable scenes, and
scriptable resources. Its MIT license permits commercial use with the required engine notices. These
capabilities suit reusable courts and data-defined trials. [S1, S2]

 Engine                Verified cost or licensing position              Fit for this project

                                                                        Recommended integrated 2D editor and content
 Godot                 Free under MIT, with notice requirements
                                                                        workflow

                       Free and source available; commercial games
 Defold                                                                 Strong alternative if Lua is a firm preference
                       permitted under its own license

                                                                        Good code-first prototype; budget for more
 LÖVE                  Free Lua framework under zlib/libpng licensing
                                                                        supporting tools

                       Free while eligible under current revenue and
 Unity Personal                                                         Capable if existing C# experience or tools justify it
                       funding terms


Defold includes scene, tilemap, particle, and Lua debugging tools; its license restricts commercializing the
engine or editor itself. LÖVE's official platform list covers desktop and mobile, so a browser route needs
separate investigation. Unity currently uses a $200,000 revenue and funding threshold over the previous
12 months for Personal eligibility, subject to its terms; its Runtime Fee was canceled and never
implemented. [S4, S5, S8, S9, S10]
Choose a stable Godot release at implementation kickoff and pin it with the matching export templates.
Use Compatibility rendering for the initial 2D slice if a future browser build matters. Current Godot web
documentation requires WebAssembly and WebGL 2.0, uses Compatibility rendering, and states that
Godot 4 C# projects cannot currently export to web. A browser demo is a separate performance and input
test. [S3]

Runtime structure
Separate the core simulation from presentation. Reusable scenes cover the courier, rival, core, court,
hazard, goal, and room transition. Data resources define encounters, rival profiles, techniques, rewards,
and art kits. A content validator resolves IDs and checks compatibility before a build includes a trial.
Keep physics-affecting randomness separate from decorative randomness. Record trial ID, revision, build,
starting state, input ticks, RNG streams, and periodic state hashes for a diagnostic replay. Replays are
supported only across compatible builds until cross-version behavior is demonstrated. A shared seed does
not guarantee identical physics, and a local replay is not an anti-cheat system.
Use explicit match states: introduction, ready, serve, rally, point resolution, result, and exit. Pause and
suspension preserve the active state. Boss transitions cancel expired timers and projectiles before creating
the next phase. A late callback from an old phase must not score, spawn a hazard, or advance the new
phase.
Write saves through a temporary file and validated replacement with a previous backup. Version the format
and test migration. If a write fails, preserve the active session and tell the player. Store general progression
separately from optional personal records so a broken replay cannot corrupt the campaign.

Performance and platform targets
Propose 1080p at 60 rendered frames per second on the development laptop, with a 720p low-effects
option. The reported 16 GB RAM and Ryzen CPU do not establish graphics performance because the
GPU has not been verified for this project. Benchmark an actual scene before advertising requirements.
Measure frame-time spikes, peak memory, texture residency, input latency, loading, repeated retries, and
scene transitions. Favor a stable frame cadence over extra particles. Load art by district, cap optional
effects, and preserve collision behavior across graphics settings.
First support AI campaign and local versus using the same simulation. Online ranked play needs a
separate decision about synchronization, latency, disconnects, fairness, and operating cost. It is outside
the first release commitment. A free engine does not remove asset, audio, testing, storefront, or distribution
costs.


16 Production milestones
Jeff owns product direction and scope. An implementation agent or developer owns the playable build and
technical evidence. Art review, gameplay review, and verification are distinct responsibilities even if one
person covers several roles. No calendar estimate becomes a commitment before the first complete district
establishes real production throughput.

 Milestone               Concrete deliverable                             Expansion condition

                         One plain court, one rival, movement,            Players can intentionally place shots and explain
 Core prototype
                         returns, scoring, retry                          goals

                                                                          Returning skills transfer and the room adds useful
 Hybrid prototype        One short breach joined to the duel
                                                                          variety

                         One finished district treatment, three duels,
                                                                          Readability, control, performance, and boss
 Art slice               one breach, one boss, two techniques, one
                                                                          fairness survive finished art
                         relic

                                                                          Each arrangement changes decisions; invalid
 Trial pilot             Three templates and 12 accepted trials
                                                                          recipes are rejected

                         First district's eight campaign encounters,      A new player can complete and resume the
 Chapter complete
                         saves, settings, local versus prototype          chapter unaided

                         Measured cost per district, boss, art kit, and   Select a sustainable first release scope and
 Production decision
                         reviewed trial                                   schedule

                         Eight districts, 64 campaign encounters, and     The actual catalog meets quality, compatibility, and
 Full target
                         up to 3,072 accepted trials                      review requirements


The art slice can serve as a public demo after verification. Its five selected campaign encounters are a
subset of the eight-encounter chapter. It is not the full campaign. If the slice exposes weak action rooms,
shorten or replace those rooms before making more. If courts are enjoyable but the enormous catalog is
not affordable to review, release a smaller accepted set and retain the expansion design.
Generate one district's production art first. Record usable-output rate, editing time, animation time, import
work, and revision cost. These measurements determine whether eight equally detailed districts are
sustainable. Reserve visual ambition for locations players actually see and for bosses whose behavior is
ready.

17 Verification and release criteria
The first meaningful proof is a playable duel. We need empirical evidence that players understand contact,
placement, and recovery. Beautiful concept images and a passing build cannot answer that question.

 Risk                              Required evidence

 Fast core misses collision        Swept-contact cases at the maximum supported speed and thin boundaries

 Goal counted twice                A goal resolves once across edge contacts, power expiry, and transitions

 Unfair initial shot               Every published serve profile leaves an intended viable response

 Body blocking dominates           Human tests show paddle control remains valuable against varied goal routes

 Boss becomes stuck                Every phase has reachable success and failure exits under retry and pause

 Generated trial is
                                   Geometry and timing validation, bot coverage, and relevant human review
 impossible

 Artwork hides danger              Moving-core review at both target resolutions and reduced effects

 Input or frame-rate changes
                                   Equivalent intended contact and scoring behavior across supported frame caps
 rules

 Progress disappears               Forced save failures, interruption, backup recovery, and version migration

 Repeated restarts degrade
                                   A representative repeated-match run with memory and frame-time inspection
 performance

 Controls exclude players          Remapping, keyboard-only menus, controller loss, assists, and text-scale review


Use deterministic unit checks for mathematical and lifecycle contracts where possible. Use scripted
scenarios for collisions, timing, transitions, and save recovery. Use human playtests for comprehension,
difficulty, visual clarity, and fun. These methods answer different questions and should be reported
separately.
During prototype playtests, observe whether newcomers can sustain an exchange, whether experienced
players choose shot placement deliberately, whether losses have understandable causes, and whether
players voluntarily choose another match. Ask specifically whether breaches improve the pacing and
whether the art distracts at critical moments. Record disagreements rather than averaging them into a
vague score.
Collect diagnostic events locally by default: encounter start and end, goal cause, trial revision, assist
profile, recovery resets, phase transitions, and failure type. Make any uploaded analytics opt-in and avoid
collecting personal information that does not help the design decision. A target win rate should be
calibrated from real players, not invented before testing.
The full release needs a complete ending, reliable saves, no known progression blockers, a published
count of accepted trials, understandable accessibility settings, required asset and engine notices, and
representative performance results. These are proposed gates. No playable build or passing game tests
exist as part of this design-document delivery.

18 Example trial record
This illustrative record shows how an encounter can be authored without embedding its rules in a separate
code branch. It is a proposed data contract, not an existing Godot API or a validated level. Use string IDs
and a string seed to preserve identity across tools. The sample's timing values require playtesting.
{
    "schema_version": 1,
    "trial_id": "last-station-gate-017",
    "content_revision": 1,
    "encounter_type": "duel",
    "district_id": "last-station",
    "court_template_id": "split-platform-02",
    "tactical_brief_id": "gate-timing",
    "scenario_seed": "0x2A7C8E110003D91F",
    "objective": {"type": "goals", "target": 5},
    "opponent": {
      "policy_id": "keeper",
      "difficulty_profile_id": "arcade-03",
      "observation_delay_ticks": 18
    },
    "hazards": [{
      "type": "timed-gate",
      "anchor_id": "central-lane",
      "open_ticks": 360,
      "closed_ticks": 240,
      "telegraph_ticks": 90
    }],
    "power_up_pool_id": "gate-safe-basic",
    "simulation": {
      "tick_rate": 120,
      "serve_grace_ticks": 120,
      "speed_profile_id": "arcade-03"
    },
    "validation_status": "unvalidated"
}

At 120 updates per second, 18 ticks represent 150 milliseconds. The implementation must convert
authored durations correctly if it changes simulation frequency. A separate certification manifest stores the
tested build, content hashes, checks run, results, and review status. The runtime must never accept
arbitrary executable code from a shared trial code.


19 Art briefs and implementation handoff
Station environment brief
Create an original painted environment for a dreamlike arcade escape game. Show an abandoned transit
concourse with stained ivory ceramic, petrol-green tile, worn brass, broken clocks with no readable
markings, and platforms disappearing into a vertical horizon. Keep the gameplay court dark and quiet;
reserve the highest local contrast for a single solid ivory core and the Returner. Use confident gouache and
oil textures, believable wear, and restrained amber light. No readable text, logos, particle storm, gore, or
generic neon signage. Supply a separate overhead gameplay composition after the environmental key art
is approved.

Cinema gameplay brief
Create a wide near-overhead view of a ruined cinema filled with shallow black water. Embed a rectangular
court in the floor, large enough for two small characters inside opposite halves. Use clean ivory
boundaries, readable left and right goals, and an uncluttered dark play surface. Put submerged oxblood

seats, brass sconces, drifting film, and a torn cloud-filled screen outside the active flight area. The courier
wears a bone-white work coat with one vermilion sleeve band. The Projectionist has a dark, elongated
silhouette. Keep the real core solid and bright. No HUD, text, logos, or decorative object that resembles the
core.

Character consistency brief
Use the approved courier image as the identity reference. Preserve coat shape, sleeve band, Returner
proportions, body scale, and material wear. Produce clear front, back, side, and diagonal pose references
under consistent neutral light, with a transparent background where requested. Keep the full feet, paddle,
and clothing visible. Avoid adding costume details between views. These are reference poses for an
animator; inspect them before creating a rig or frame set.

First implementation assignment
Build only the core prototype described in milestone one. Before coding, inspect the repository instructions
and verify the chosen stable Godot version. Create a Windows-playable project with a plain court, one
core, one physical rival, courier movement, aiming, passive return, active Strike, Dash, score, pause, and
immediate Retry.
Use one flat collision plane, the documented body-contact rule, bounded speed, swept fast-core collision,
and the first-to-five match rule. Keep encounter data separate from art and simulation. Show the rival's
physical limitations. Provide a debug view for collision shapes, contact order, core speed, current match
state, and AI target.
Demonstrate deliberate scoring through a bank, a legal emergency body block, an ordinary loss, a retry, a
pause during a moving rally, and a controller disconnect. Run focused checks for tunneling, duplicate
goals, trapped cores, stale callbacks, and input changes. Record what was tested and what remains
uncertain. Do not claim the duel is fun because it compiles.
After the first review, add one breach room using the same returning behavior. Add the sidearm only when
its purpose is clear. Introduce approved art after the interaction is understandable, then repeat the
readability and performance checks. Stop expanding content when a core issue remains unresolved.


20 Decisions for the next design review
The default proposal is ready for a prototype. The next review should use that prototype to decide whether
the court movement feels better with a front-mounted paddle or a slightly broader return surface; whether a
sidearm improves breach rooms; whether first-to-five produces the intended pacing; and whether mouse
and controller aiming both support deliberate placement.
The artistic review should select one production direction from the generated concepts, confirm the
courier's silhouette, and approve the difference between cinematic key art and actual gameplay framing. It
should also determine the cost of turning one concept into usable layers and animation.
The production review should set a sustainable first release scope after the completed chapter. The 64-
encounter campaign and 3,072-trial catalog remain explicit full-game targets. Scope can grow through
complete, verified districts while preserving a coherent escape story.

21 Sources
Official sources checked on November 3, 2026. External sources support engine capabilities, licensing
descriptions, nearby-game comparisons, and Steam's content-survey process. The fictional world,
mechanics, counts, tuning, and production plan are original design proposals in this document.
[S1] Godot Engine. License. MIT licensing and required notices. https://godotengine.org/license/
[S2] Godot Engine. Features. Dedicated 2D workflow, reusable scenes, and custom resources.
https://godotengine.org/features/
[S3] Godot documentation. Exporting for the Web. Current web rendering, language, and platform constraints.
https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html
[S4] Unity. Unity Personal. Current free-plan eligibility information. https://unity.com/products/unity-personal
[S5] Unity. Pricing updates. Revenue and funding thresholds and Runtime Fee cancellation.
https://unity.com/products/pricing-updates
[S6] Team Reptile. Lethal League Blaze press kit. Projectile-fighting and story-mode comparison. https://team-
reptile.com/press/sheet.php?p=Lethal_League_Blaze
[S7] Dotemu. Windjammers 2. Disc-play mechanics and hand-drawn art comparison.
https://www.dotemu.com/games/windjammers-2/
[S8] LÖVE. Official homepage. Lua framework, commercial use, and official platform list. https://love2d.org/

[S9] Defold. Official homepage. Lua, visual tools, and supported platform information. https://defold.com/
[S10] Defold. The Defold License. Commercial-game permissions and engine restrictions.
https://defold.com/license/
[S11] Valve. Steamworks Content Survey. Disclosure of pre-generated and live-generated AI content.
https://partner.steamgames.com/doc/gettingstarted/contentsurvey