# 09 — Writing style (ASD-STE100)

Write all English prose in the style of ASD-STE100, Simplified Technical English (STE). Source: https://www.asd-ste100.org

## Where to use it
- READMEs and everything in `docs/`.
- Code comments, docstrings, and `--help` text.
- Commit messages and log messages.

## Where not to use it
- Code, identifiers, commands, and file names.
- Tool output and quoted text.
- Chat with the user. Use the language of the user.

## Words
- Use simple, common words: "use", not "utilize". "Start", not "initiate".
- Use one word for one meaning, and one meaning for one word. Do not use synonyms for variation: if the text says "sample", do not change to "specimen".
- Use technical names without change: `haplotype`, `BAM`, `allele`, `hap-ibd`.
- Do not use more than 3 nouns in a row. Write "the filter for low-quality reads", not "low-quality read filter step output".

## Sentences
- Procedures: 20 words or fewer. Descriptions: 25 words or fewer.
- Write one instruction in each sentence.
- Use the active voice.
- Use simple verb tenses: present, past, and future.
- Do not use "-ing" verb forms as a main verb.
- Keep the articles ("the", "a"). Do not remove words only to make a sentence short.

## Procedures
- Use the imperative: "Run the workflow."
- Put a warning before the step that it applies to.
- Use a numbered list when the order is important.

## Descriptions
- Put the most important information first.
- Write one topic in each paragraph, with 6 sentences or fewer.
- Use a vertical list for items, not a long sentence.

## Limits
- The full STE dictionary is not in this repo, so this is a style guide, not a claim of conformity. Do not say that a text is "STE compliant".
- Do not rewrite existing text only to apply this style. Apply it to new text and to the text that you change.
