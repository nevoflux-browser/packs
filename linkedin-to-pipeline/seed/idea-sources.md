# Idea Sources

Where `linkedin-idea-mining` looks, in two layers: **Internal** (your team, broadly) and
**External** (your market). Fill in the concrete handles/URLs; add, remove, and edit the
mining rules freely — the agent treats your edits as the source of truth.

## Internal — the team (broadly)

The people, product, and users whose real material holds your differentiated stories.
Extraction target: **stories and proof no one else can copy**. This layer feeds the story
lenses in `conventions/story-mining.md` and seeds the interview questions.

- **People** — founders/teammates: GitHub profiles, x.com/LinkedIn handles, personal sites,
  talks: *(list them)*
- **Product** — repos to watch (releases/commits): *(repo URLs)* · changelog: *(URL)* ·
  docs / issue tracker: *(URLs)*
- **Users** — your test crew, honorary team members: feedback channels, community spaces,
  review sites: *(list them)*

## External — the market

What the niche cares about, what competitors do, where the live conversations (heat) are.
Extraction target: **angles, gaps, timing**. External gives the timing; Internal gives the
evidence — the combination is the strongest post.

- **reddit:** *(e.g. r/sales, r/startups)*
- **x.com:** *(accounts or list URLs)*
- **知乎 / 小红书 / 微博:** *(topics or accounts)*
- **LinkedIn competitors:** *(profile URLs to study)*
- **Industry communities / newsletters:** *(list them)*

## Mining rules (defaults — edit freely)

Internal:

- `github release / changelog entry` → BOFU product demo / MOFU how-to (just-shipped lens)
- `user question / complaint / praise` → MOFU or BOFU via the user-signal lens
- `teammate post / talk` → TOFU story / MOFU framework
- *(add your own)*

External:

- `recurring question on reddit / 知乎` → MOFU framework / TOFU contrarian take
- `competitor post` → break down its structure, then change the angle
- `hot topic in the niche` → may initiate a post **only if** the Internal layer yields
  evidence to carry it (see `story-mining.md`)
- *(add your own)*
