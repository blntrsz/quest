import { $ } from "bun";
import { describe, expect, it } from "bun:test";
import { resolve } from "node:path";

const root = resolve(import.meta.dirname, "..");

describe("list scripts", () => {
  it("lists abilities as XML", async () => {
    expect(
      await $`${resolve(root, "skills/ability/scripts/list.sh")}`
        .cwd(root)
        .quiet()
        .text(),
    ).toMatchSnapshot();
  });

  it("lists quests as XML", async () => {
    expect(
      await $`${resolve(root, "skills/quest/scripts/list.sh")}`
        .cwd(root)
        .quiet()
        .text(),
    ).toMatchSnapshot();
  });
});

describe("load scripts", () => {
  it("loads every ability", async () => {
    const abilitiesDir = resolve(root, "skills/ability/abilities");
    const abilityNames = [];
    for await (const file of new Bun.Glob("*.md").scan({ cwd: abilitiesDir })) {
      abilityNames.push(file.slice(0, -3));
    }

    expect(abilityNames.length).toBeGreaterThan(0);
    abilityNames.sort();
    expect(
      await $`${resolve(root, "skills/ability/scripts/load.sh")} ${abilityNames}`
        .cwd(root)
        .quiet()
        .text(),
    ).toMatchSnapshot();
  });

  it("loads every quest", async () => {
    const questsDir = resolve(root, "skills/quest/quests");
    const questNames = [];
    for await (const file of new Bun.Glob("*.md").scan({ cwd: questsDir })) {
      questNames.push(file.slice(0, -3));
    }

    expect(questNames.length).toBeGreaterThan(0);
    questNames.sort();
    expect(
      await $`${resolve(root, "skills/quest/scripts/load.sh")} ${questNames}`
        .cwd(root)
        .quiet()
        .text(),
    ).toMatchSnapshot();
  });

  it("loads a quest by its bare type name", async () => {
    const loadScript = resolve(root, "skills/quest/scripts/load.sh");
    const bare = await $`${loadScript} decision`.cwd(root).quiet().text();
    const suffixed = await $`${loadScript} decision-quest`.cwd(root).quiet().text();

    expect(bare.startsWith('<quest name="decision">\n')).toBe(true);
    expect(suffixed.startsWith('<quest name="decision-quest">\n')).toBe(true);
    expect(bare).toBe(
      suffixed.replace('<quest name="decision-quest">', '<quest name="decision">'),
    );
  });
});
