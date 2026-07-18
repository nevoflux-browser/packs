#!/usr/bin/env python3
"""Stand-in for `nevoflux pack validate` — checks pack.toml invariants and skill frontmatter.
Usage: python scripts/validate.py [--structure]
  --structure : only manifest-internal checks (no referenced-file existence / frontmatter).
Run from the pack root (the dir containing pack.toml)."""
import sys, re, tomllib, pathlib

ROOT = pathlib.Path(__file__).resolve().parent.parent
errors, notes = [], []

def err(m): errors.append(m)

def load_toml():
    p = ROOT / "pack.toml"
    if not p.exists():
        err("pack.toml missing"); return None
    try:
        return tomllib.loads(p.read_text(encoding="utf-8"))
    except Exception as e:
        err(f"pack.toml does not parse: {e}"); return None

def frontmatter(md_path):
    text = md_path.read_text(encoding="utf-8")
    m = re.match(r"^---\n(.*?)\n---\n", text, re.S)
    if not m: return None
    fm = {}
    for line in m.group(1).splitlines():
        mm = re.match(r"^([A-Za-z_]+):\s*(.*)$", line)
        if mm: fm[mm.group(1)] = mm.group(2).strip()
    return fm

def check_structure(cfg):
    pack = cfg.get("pack", {})
    for k in ("name", "version", "protocol", "min_nevoflux"):
        if k not in pack: err(f"[pack] missing '{k}'")
    name = pack.get("name", "")
    if not re.fullmatch(r"[a-z0-9-]+", name): err(f"[pack].name '{name}' fails [a-z0-9-]+")
    if pack.get("protocol") != "pack-protocol/0.1": err("protocol must be pack-protocol/0.1")
    if "config" in cfg.get("components", {}): err("[components.config] is forbidden")
    if "knowledge" in cfg.get("components", {}): err("[components.knowledge] unsupported in 0.1")
    ns = pack.get("namespace", name)
    seeds = cfg.get("components", {}).get("seed", [])
    prefixes = cfg.get("components", {}).get("protected", {}).get("prefixes", [])
    pslugs = cfg.get("components", {}).get("protected", {}).get("slugs", [])
    for s in seeds:
        slug, frm = s.get("slug", ""), s.get("from", "")
        if not slug.startswith(ns + "/"): err(f"seed slug '{slug}' not in namespace '{ns}/'")
        if frm.startswith("/") or frm.startswith("\\") or ".." in frm or re.match(r"^[A-Za-z]:", frm):
            err(f"seed 'from' path not relative/safe: {frm}")
        covered = any(slug == ps for ps in pslugs) or any(slug.startswith(p) for p in prefixes)
        if not covered: err(f"seed '{slug}' not covered by protected (seed must be a subset of protected)")
    sk = cfg.get("components", {}).get("skills", {}).get("dir")
    if sk != "skills": err(f"[components.skills].dir should be 'skills', got {sk!r}")
    return seeds

def check_files(cfg, seeds):
    for s in seeds:
        if not (ROOT / s["from"]).exists(): err(f"seed file missing: {s['from']}")
    skdir = ROOT / "skills"
    found = sorted(p.parent.name for p in skdir.glob("*/SKILL.md"))
    for d in found:
        fm = frontmatter(skdir / d / "SKILL.md")
        if fm is None: err(f"{d}/SKILL.md has no YAML frontmatter"); continue
        for k in ("name", "description", "version", "author", "enabled", "allowed_tools"):
            if k not in fm: err(f"{d}/SKILL.md frontmatter missing '{k}'")
        if fm.get("name") and fm["name"] != d:
            err(f"{d}/SKILL.md name '{fm.get('name')}' != dir '{d}'")
    notes.append(f"skills found: {found}")

def main():
    structure_only = "--structure" in sys.argv
    cfg = load_toml()
    if cfg is None:
        print("\n".join(errors)); sys.exit(1)
    seeds = check_structure(cfg)
    if not structure_only:
        check_files(cfg, seeds)
    for n in notes: print("note:", n)
    if errors:
        print("FAIL:"); [print("  -", e) for e in errors]; sys.exit(1)
    print("OK" + (" (structure only)" if structure_only else ""))

if __name__ == "__main__":
    main()
