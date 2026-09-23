import { spawnSync } from "node:child_process";
import {
  chmodSync,
  copyFileSync,
  mkdirSync,
  mkdtempSync,
  rmSync,
  symlinkSync,
  writeFileSync,
} from "node:fs";
import { dirname, join, resolve } from "node:path";
import { afterEach, describe, expect, it } from "bun:test";

const root = resolve(import.meta.dirname, "..");
const temporaryRoots = [];

afterEach(() => {
  for (const path of temporaryRoots.splice(0)) {
    rmSync(path, { force: true, recursive: true });
  }
});

function createFixtureRunbook(abilitiesFrontmatter) {
  const fixtureRoot = mkdtempSync(join(root, ".test-quest-loader-"));
  temporaryRoots.push(fixtureRoot);

  const questScripts = join(fixtureRoot, "skills/quest/scripts");
  const questDirectory = join(fixtureRoot, "skills/quest/quests");
  const abilityScripts = join(fixtureRoot, "skills/ability/scripts");
  const abilityDirectory = join(fixtureRoot, "skills/ability/abilities");
  for (const directory of [questScripts, questDirectory, abilityScripts, abilityDirectory]) {
    mkdirSync(directory, { recursive: true });
  }

  for (const [source, destination] of [
    ["skills/quest/scripts/load.sh", join(questScripts, "load.sh")],
    ["skills/ability/scripts/load.sh", join(abilityScripts, "load.sh")],
  ]) {
    copyFileSync(join(root, source), destination);
    chmodSync(destination, 0o755);
  }

  writeFileSync(
    join(questDirectory, "fixture-quest.md"),
    `---\nname: fixture\ndescription: Fixture runbook.\n${abilitiesFrontmatter}---\n\nRun the fixture.\n`,
  );
  writeFileSync(
    join(abilityDirectory, "known.md"),
    "---\nname: known\ndescription: A fixture ability.\n---\n\nAbility body.\n",
  );

  return {
    loader: join(questScripts, "load.sh"),
    abilityDirectory,
    fixtureRoot,
  };
}

describe("quest loader ability declarations", () => {
  it("loads the abilities declared by a selected runbook", () => {
    const result = spawnSync("bash", [join(root, "skills/quest/scripts/load.sh"), "task"], {
      encoding: "utf8",
    });

    expect(result.status).toBe(0);
    for (const name of ["enrich", "code-review", "security-review", "unslop"]) {
      expect(result.stdout).toContain(`<ability name="${name}">`);
    }
    expect(result.stdout).toContain("# Enrich");
  });

  it("rejects an invalid ability name before emitting the runbook", () => {
    const { loader } = createFixtureRunbook("abilities:\n  - ../escape\n");
    const result = spawnSync("bash", [loader, "fixture"], { encoding: "utf8" });

    expect(result.status).not.toBe(0);
    expect(result.stdout).toBe("");
    expect(result.stderr).toContain("invalid abilities frontmatter");
  });

  it("reports an ability name that has no matching ability file", () => {
    const { loader } = createFixtureRunbook("abilities:\n  - missing-ability\n");
    const result = spawnSync("bash", [loader, "fixture"], { encoding: "utf8" });

    expect(result.status).not.toBe(0);
    expect(result.stdout).toBe("");
    expect(result.stderr).toContain("missing ability: missing-ability");
  });

  it("does not require the ability loader for runbooks without dependencies", () => {
    const { loader } = createFixtureRunbook("");
    rmSync(join(dirname(loader), "../../ability"), { force: true, recursive: true });
    const result = spawnSync("bash", [loader, "fixture"], { encoding: "utf8" });

    expect(result.status).toBe(0);
    expect(result.stdout).toContain('<quest name="fixture">');
  });

  it("rejects an ability file that is a symbolic link", () => {
    const { loader, abilityDirectory, fixtureRoot } = createFixtureRunbook("abilities:\n  - known\n");
    const abilityPath = join(abilityDirectory, "known.md");
    const outsidePath = join(fixtureRoot, "outside.md");
    rmSync(abilityPath);
    writeFileSync(outsidePath, "fixture-only secret\n");
    symlinkSync(outsidePath, abilityPath);
    const result = spawnSync("bash", [loader, "fixture"], { encoding: "utf8" });

    expect(result.status).not.toBe(0);
    expect(result.stdout).toBe("");
    expect(result.stderr).toContain("invalid ability file (symbolic link): known");
    expect(result.stdout).not.toContain("fixture-only secret");
  });
});
