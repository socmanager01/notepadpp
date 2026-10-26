# V2 review notes

The V1 baseline was cloned from commit `9f084ee`. The original XML files have not been modified.

## V2 preview implementation

`build-v2.ps1` produces the Light/Dark V2 XML files from shared keyword lists. Light associates `eml emlx mbox`; Dark is selected manually. Both use UTF-8 declarations, eight populated groups, neutral result styling, and the original V1 colors and bold emphasis. The custom X-field rule is restricted to column one; ordinary keywords remain unanchored. Short DKIM tag matching, exact IP recognition, and semantic header/body parsing are excluded.

`check-v2.ps1` passes for both variants: 116 unique keywords each, required field coverage, matching-rule parity, and restoration of the V1 palette mappings. These are structural checks, not a lexer or visual test.

Manual testing confirmed EML, EMLX, and MBOX highlighting and automatic Light selection. Further Dark-theme and edge-case verification remains pending. Use `samples/email-header-v2.eml` and `samples/edge-cases.txt` in both palettes. Inspect no-space field values, punctuation-adjacent parameters, custom-X precedence, mixed case, folded lines, line-ending variations, and unmatched delimiters. Do not label the preview a validated release until those checks are complete.

The historical [13Cubed Sublime syntax](https://github.com/13Cubed/EmailHeader/blob/master/EmailHeader.sublime-syntax) informed the comparison of line-start matching and IP highlighting. Its regex implementation has not been copied into this UDL.

## Findings from the definitions

- Both variants claim `eml emlx mbox`, so automatic selection needs an explicit policy when both are installed.
- Neither file includes an XML encoding declaration. Add a UTF-8 declaration before submitting to the official UDL Collection.
- `Resent-From:` appears twice in Keywords3.
- Keywords4 through Keywords8 are unused. Potential additions should be grouped deliberately rather than appended without reviewing parsing precedence.
- The current explicit authentication field list omits ARC fields. Review modern header coverage for V2.
- Dark V2 applies the reported community suggestions: blue `0000FF` becomes `508C9B`, and purple `800080` becomes `E3A5C7`. Light remains unchanged. Dark-theme visual verification is still pending.
- The `x-` rule is implemented using the line-comment configuration. Its placement, punctuation handling, and effect on later styles need visual checks.
- Delimiter rules can span text that is not a header value. Check unmatched delimiters, folded headers, and the transition from headers to body.

## Suggested verification cases

Use synthetic data for mixed-case field names, adjacent field punctuation, folded headers, Received chains, authentication results, ARC fields, encoded subjects, IPv4/IPv6 text, and message bodies that contain header-like strings. Verify both palettes in Notepad++ and confirm rules remain identical between variants.

## Integration details to confirm

- Confirm whether the maintainer requested a UDL Collection listing or inclusion in the application distribution. A README alone does not implement either route.
- Historical Light/Dark installation video links are confirmed and included in the README.
- Confirm the intended distribution license with the author before adding a license file.
- Agree on V2 display names and extension association behavior before changing the definitions.

Sources: [official UDL manual](https://npp-user-manual.org/docs/user-defined-language-system/) and [UDL Collection contribution requirements](https://github.com/notepad-plus-plus/userDefinedLanguages/blob/master/CONTRIBUTING.md).
