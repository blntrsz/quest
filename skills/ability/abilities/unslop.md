---
name: unslop
description: Cut AI tells from any writing. The patterns below are the catalog, and each comes with its fix. Apply to every piece of prose this repo produces, or when a doc reads as AI generated.
---

Remove the writing patterns below from prose in this repo while preserving its meaning and intended tone. Apply this ability to every piece of prose as you write and again before handoff, not as a separate final pass.

## Process

1. **Scan** for the patterns below.
2. **Rewrite.** Preserve the meaning, and match the intended tone.
3. **Self-audit.** Ask "What makes this obviously AI generated?" Fix what remains.

Rule numbers are stable ids that other docs cite, so a removed rule leaves a gap. The numbers below skip.

## Content

3. **Superficial -ing phrases.** "highlighting", "ensuring", "reflecting", "showcasing", "fostering". Delete them, or expand with the real source.
5. **Vague attributions.** "Experts believe", "Industry reports suggest", "Some critics argue". Name the source or delete the claim.

## Language

7. **AI vocabulary.** Additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape (abstract), pivotal, showcase, tapestry (abstract), testament, underscore, vibrant. Use the plain word.
8. **Fancy ways to say "is".** "serves as", "stands as", "boasts", "features". Say "is" or "has".
9. **"Not just X, but Y."** State the point directly.
10. **Rule of three.** Forcing ideas into groups of three. Use the natural number.
11. **Synonym cycling.** "Protagonist", "main character", "central figure", and "hero" in one paragraph. Pick one word, and repeat it.
12. **False ranges.** "from X to Y" where X and Y are not on a meaningful scale. List the topics directly.

## Style

13. **Em dash overuse.** Use periods or commas. An em dash, an en dash, or a hyphen standing in for a dash reads as a tell. Keep parentheses out as well; when a thought needs separating, end the sentence.
14. **Colon overuse.** A colon is fine before a list or an example. Mid-sentence it is a crutch. "If you're coming from traditional automation: instead of registering event handlers, you describe conditions" adds nothing. Rewrite so the point stands alone: "Describing when the scheduler should fire works best as plain English."
15. **Boldface overuse.** Bold the few words that carry the point. Bolding every proper noun or acronym flattens the page.
16. **Inline-header lists.** The tell is a bold label and colon that restates the line: "**Performance:** Performance improved." Convert those to prose. A bold lead-in that names the item, ends in a period, and is followed by genuinely new detail is fine: "**Schema in TypeScript.** Tables live in one file."
17. **Title case headings.** Use sentence case.
18. **Decorative emojis.** Remove them from headings and bullets.
19. **Curly quotes.** Replace them with straight quotes.

## Communication artifacts

20. **Chatbot phrases.** "I hope this helps!", "Let me know if...", "Of course!", "Certainly!", "Found the smoking gun!" Remove them.
22. **Sycophantic tone.** "Great question! You're absolutely right!" Respond directly instead.

## Filler

23. **Filler phrases.** "In order to" becomes "To". "Due to the fact that" becomes "Because". "It is important to note that" gets deleted.
24. **Excessive hedging.** "could potentially possibly be argued that it might" becomes "may".
25. **Generic conclusions.** "The future looks bright." State specific plans or facts.

## Jargon

26. **Abstract metaphor nouns.** Substrate, wedge, vector, locus, vantage, nexus, primitive (as a noun), harness (as a metaphor), surface (as in "API surface"), bedrock, scaffolding (as a metaphor), modality, paradigm, gold-plating, ratchet (as a metaphor), evacuate (for moving code), endgame, north star, flywheel. These read as technical but usually have a plainer concrete word. "Substrate" becomes "base". "Wedge in" becomes "add". "Vector" becomes "way" or "method". "Gold-plating" becomes "more than the job needs". "Ratchet" becomes the mechanism's real name or "a limit that only tightens". "Evacuate" becomes "move out". "Endgame" becomes "the last phase". Pick the concrete word.

## Plain speech

27. **Say what it does, not how it feels.** "the database stays close at hand", "SQL you can read", "types that follow your schema" name a feeling. The fix names the mechanism or a number: "`.toSQL()` returns the exact string sent to the database", "a column rename fails the build". Ask what the sentence tells the reader to do or know, and write that. When you cannot restate it as a concrete instruction, fact, or number, cut it. One more check: a sentence that could appear unchanged in another project's docs says nothing about this one. Cut it.
28. **Shorten or split dense sentences.** When the reader has to backtrack to parse a sentence, break it in two or drop clauses. One idea per sentence.
29. **Active voice.** Name the actor: "queries are validated" becomes "the compiler validates queries", "the file is parsed by the loader" becomes "the loader parses the file". Passive is fine when the actor is unknown or genuinely does not matter.
30. **Cut adverbs, or use a stronger verb.** "runs quickly" becomes "is fast" or the number. "significantly improves" becomes the measured delta. An adverb propping up a weak verb means the verb is wrong.
31. **Prefer the plain word.** "utilize" becomes "use", "leverage" becomes "use", "facilitate" becomes "help", "numerous" becomes "many", "in the event that" becomes "if". The fancier synonym is rarely clearer.
32. **Mannered prose.** Metaphor or flourish where a literal phrase exists: aphorisms ("wire it or delete it"), rhetorical fragments for effect, personified code ("the plan holds it"), figurative verbs ("rides along", "stands on"), stock framing phrases. "A dial worth turning" becomes "a parameter worth varying". Say what you mean. Rule 26 covers the metaphor nouns.
33. **Over-compression.** Dropped articles, verbless fragments, symbol-speak, and abbreviations make the reader decode instead of read. "Parser rejects bad date → exit 2, no write" becomes "The parser rejects a bad date, exits with code 2, and writes nothing." Write whole sentences with their articles and verbs, and spell out arrows and abbreviations.

## Done when

No pattern above survives in the text, and the meaning is unchanged.
