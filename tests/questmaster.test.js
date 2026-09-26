import { readFileSync } from "node:fs";
import { resolve } from "node:path";
import { describe, expect, it } from "bun:test";

const root = resolve(import.meta.dirname, "..");
const skill = readFileSync(resolve(root, "skills/questmaster/SKILL.md"), "utf8");

describe("questmaster routing guidance", () => {
  it("uses the ability catalog to match described needs", () => {
    expect(skill).toContain("skills/ability/scripts/list.sh");
    expect(skill).toContain("match its descriptions");
    expect(skill).toContain("`/ability <name>`");
    expect(skill).toContain("load/run distinction");
  });

  it("routes goals and adventure links to the adventure workflow", () => {
    expect(skill).toContain("`/adventure` with the user's goal or an adventure link");
    expect(skill).toContain("plan for quests");
  });

  it("routes bounded tasks and standalone quest links to the quest workflow", () => {
    expect(skill).toContain("`/quest` with a bounded objective or a confirmed standalone quest link");
    expect(skill).toContain("If the quest is standalone, it directs the user to `/quest`");
  });

  it("checks an unknown quest link's parent before routing", () => {
    expect(skill).toContain("`/adventure` to verify whether it belongs to an adventure");
  });

  it("asks when the user has not said whether they want a task or broader outcome", () => {
    expect(skill).toContain("ask which they mean");
  });
});
