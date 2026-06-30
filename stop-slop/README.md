# stop-slop

**English** · [中文](README.zh.md)

A bilingual NevoFlux pack that strips **AI writing tells** from prose — in Chinese or English.
Install it, then invoke with `/no-slop`.

## Usage

```
/no-slop rewrite this so it doesn't read like a model wrote it: <text>
/no-slop write a post about X
```

`/no-slop` automatically:

- **detects the language** — Chinese text uses the ZH ruleset, English the EN ruleset; the two are never mixed;
- **detects the mode** — existing text → rewrite (facts and stance preserved); a writing instruction → generate from scratch;
- **gauges the register** — formal email / technical docs / announcements aren't force-fed casual phrasing or punctuation swaps;
- runs a **quality check** when done and appends a compact report.

## How it works

`/no-slop` loads the `no-slop` skill. The skill detects the target language, reads the matching rule
set, rewrites or generates accordingly, then self-checks against the hard rules. The full
banned-word / structure lists live in `references/` and are loaded at call time (see Layout).

## Layout

```
stop-slop/
  pack.toml
  skills/no-slop/
    SKILL.md
    references/
      en-phrases.md  en-structures.md  en-examples.md
      zh-banned-words.md  zh-banned-punctuation.md  zh-banned-structures.md
      zh-phrases.md  zh-examples.md
```

Hard-rule references load when `/no-slop` runs: the SKILL body reads the language-matched set via
`skill_read` (this is what the native agent relies on); some runtimes (the ACP bridge) also
eager-inject them from the frontmatter `dependencies`. Examples are read on demand.

## Credits

The Chinese and English rule sets are each adapted from an MIT-licensed project — see `NOTICE` and
`LICENSE`.

- [hardikpandya/stop-slop](https://github.com/hardikpandya/stop-slop) — English rules
- [pencil20388-eng/stop-slop-zh](https://github.com/pencil20388-eng/stop-slop-zh) — Chinese rules

## License

MIT
