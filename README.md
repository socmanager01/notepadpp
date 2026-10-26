# Email Header Highlighting for Notepad++

Two User Defined Languages (UDLs) by [SocManager.com](https://socmanager.com/) that make raw email headers easier to inspect in Notepad++.

## Download

### V2 preview

The V2 definitions are available for evaluation. Structural checks pass. Manual testing confirmed highlighting and automatic Light selection for EML, EMLX, and MBOX. Further Dark-theme and malformed-input checks remain pending.

| Variant | Definition |
| --- | --- |
| Light V2 | [EmailHeader_SocManager_Light_v2.xml](EmailHeader_SocManager_Light_v2.xml) |
| Dark V2 | [EmailHeader_SocManager_Dark_v2.xml](EmailHeader_SocManager_Dark_v2.xml) |

Use GitHub's **Raw** download for these files, then follow the import instructions below. Select **Email Header Light - SocManager.com - V2** or **Email Header Dark - SocManager.com - V2** from the Language menu.

V2 adds ARC fields, attachment metadata, list and client fields, authentication parameter prefixes, and Microsoft filtering metadata. Both palettes have 116 unique keyword entries and identical matching rules. Colors and bold emphasis follow the original V1 palettes, with two Dark-only readability adjustments from community feedback: purple `800080` becomes pink `E3A5C7`, and blue `0000FF` becomes light blue `508C9B`. Routing and authentication fields (including ARC) share the original authentication color; identity and MIME fields share the original identity color. Parentheses, angle brackets, and encoded words retain their V1 styles. Light explicitly uses a white background and Dark uses `#202020`, preventing white default text from inheriting a white editor background. When both variants are installed, assign extensions only to your preferred variant.

Light V2 associates `eml emlx mbox` for automatic highlighting. Dark V2 has no extension associations and is selected manually. If multiple V1/V2 palettes are installed, keep these extensions only on your preferred variant in the UDL dialog to make automatic selection unambiguous. Readable raw headers in `.txt` or extensionless files work through manual selection. Outlook `.msg`, `.pst`, and `.ost` require extraction/export first; they are not directly supported binary formats.

Parameter prefix matching colors a matching token and its attached value. Exact result words use a neutral color. Keywords are not restricted to the header section or column one. The generic `X-` rule is restricted to column one, but can take precedence over the more specific vendor field styling. Whitespace and punctuation can affect keyword recognition; short DKIM tags and precise IP recognition are deliberately not implemented. The [edge cases](samples/edge-cases.txt) include these limitations for visual review.

Open the [synthetic message](samples/email-header-v2.eml) to evaluate both palettes. Its signatures and authentication assertions are fictional. See [coverage notes](COVERAGE.md) for planned versus implemented scope.

### Original V1

| Variant | XML definition | Language menu entry |
| --- | --- | --- |
| Light | [Download Light V1](https://raw.githubusercontent.com/socmanager01/notepadpp/master/01-npp-email-header-light-socmanager.com-v1.xml) | Email Header Light - SocManager.com - V1 |
| Dark | [Download Dark V1](https://raw.githubusercontent.com/socmanager01/notepadpp/master/02-npp-email-header-dark-socmanager.com-v1.xml) | Email Header Dark - SocManager.com - V1 |

Save the raw XML file, rather than a GitHub HTML page. Choose the variant that matches your editor background; selecting a UDL does not switch the Notepad++ application theme.

## Install and use

1. Download the desired XML definition.
2. In Notepad++, select **Language > User Defined Language > Define your language...**.
3. Select **Import...**, then choose the downloaded XML file.
4. Close the dialog and restart Notepad++.
5. Open a raw email or paste its headers into a document, then choose the corresponding **Email Header** entry in the **Language** menu.

Menu wording can vary by Notepad++ version. See the [official UDL manual](https://npp-user-manual.org/docs/user-defined-language-system/) for configuration details.

Both V1 definitions associate `eml emlx mbox` extensions. If both variants are installed, select the intended language explicitly. To give one variant automatic selection, keep those extensions only on that variant using the UDL dialog's **Ext.** field.

To update an existing installation, back up any customized definition using **Export...**, remove the old named definition in the UDL dialog, and import its replacement. Avoid importing repeated copies with the same language name.

## What V1 highlights

- Transport and authentication field names, including `Received:`, `Authentication-Results:`, `Received-SPF:`, and `DKIM-Signature:`.
- Sender, recipient, subject, date, message identifier, and MIME field names.
- Additional list, thread, reply, and resent-message field names.
- Configured `x-` tokens, parenthesized text, angle-bracketed text, and encoded-word delimiters (`=?` to `?=`).

Matching is case-insensitive. The definitions use UDL keyword groups and delimiters; they do not parse the email message structure. Highlighting can therefore also occur in message bodies or other matching text. Encoded words are highlighted, not decoded. These files do not perform SPF, DKIM, or DMARC verification.

## Maintainer information

Repository: [socmanager01/notepadpp](https://github.com/socmanager01/notepadpp)

Each XML file contains one `UserLang` definition using UDL format 2.1. The Light and Dark variants within each version share matching rules and differ in their styles. There is no accompanying auto-completion or Function List definition.

Run `powershell -File .\build-v2.ps1` to regenerate V2 from the shared rules, and `powershell -File .\check-v2.ps1` to check XML, required coverage, duplicate keywords, rule parity, and matching-rule consistency. These checks do not execute the Notepad++ lexer.

For the official [Notepad++ UDL Collection](https://github.com/notepad-plus-plus/userDefinedLanguages), follow its [contribution instructions](https://github.com/notepad-plus-plus/userDefinedLanguages/blob/master/CONTRIBUTING.md): provide unique definition names, UTF-8 XML with an encoding declaration, and entries in `udl-list.json`. An illustrative sample is recommended. Collection inclusion and shipping a language preinstalled are separate integration decisions; this repository does not claim either has been accepted.

## Installation videos

SocManager.com has published two historical installation tutorials. Their direct YouTube URLs still need to be confirmed before they are linked here.

## Feedback

Report highlighting problems through [GitHub Issues](https://github.com/socmanager01/notepadpp/issues). Include the variant and Notepad++ version, plus a small anonymized header example and the expected highlighting.
