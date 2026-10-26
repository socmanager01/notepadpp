# V2 email format and highlighting coverage

This is the proposed scope, not a claim that V1 already implements these rules. Extensions identify likely input; the readable message content determines whether UDL highlighting is useful.

V2 preview status: the generated XML implements the eight categories below as keyword groups, with selected entries rather than every proposed pattern. It excludes short DKIM/ARC tags, segmented extended filename parameters, exact IP/URL matching, and header/body parsing. Group 7 uses token-prefix matching; group 8 uses exact neutral-colored words. Generic X-field styling can override specific X-field keyword styles. Light V2 associates `eml emlx mbox` for automatic selection; Dark V2 is selected manually. See the README for limitations and the sample probes; lexer/visual verification remains pending.

## File formats

| Input | Proposed handling |
| --- | --- |
| `.eml` | Primary target: raw Internet message headers and MIME content. |
| `.emlx` | Highlight the message portion; Apple Mail also includes a byte count and metadata plist. Do not claim to parse that wrapper. |
| `.mbox` | Highlight headers across a text mailbox; do not claim mailbox parsing or reliable message-boundary detection. |
| `.msg` | Outlook compound binary container. Extract/export the transport headers or message to text/EML first. Do not associate this extension with the UDL. |
| `.pst`, `.ost` | Outlook data stores; export individual messages first. Do not associate these extensions. |
| Header-only `.txt` or extensionless raw message | Select Email Header manually. Avoid taking over every text file. |

Sources: [Library of Congress email format catalog](https://www.loc.gov/preservation/digital/formats/fdd/email_fdd.shtml), [EMLX](https://www.loc.gov/preservation/digital/formats/fdd/fdd000615.shtml), [MBOX](https://www.loc.gov/preservation/digital/formats/fdd/fdd000383.shtml), [Microsoft MSG structure](https://learn.microsoft.com/en-us/openspecs/exchange_server_protocols/ms-oxmsg/cd44ec9f-01bb-4ea3-b335-87cfeb827594), and [Outlook data files](https://support.microsoft.com/en-us/outlook/create-an-outlook-data-file-pst-to-save-your-information).

## Proposed eight keyword groups

These are design categories. Test token boundaries and UDL parsing precedence before assigning literal entries, especially short tokens and punctuation-adjacent parameters.

| Group | Candidate entries |
| --- | --- |
| 1: Routing and delivery | `Received:`, `Return-Path:`, `Delivered-To:`, `X-Original-To:` |
| 2: Identity and conversation | `From:`, `Sender:`, `Reply-To:`, `To:`, `Cc:`, `Bcc:`, `Date:`, `Subject:`, `Message-ID:`, `In-Reply-To:`, `References:`, standard `Resent-*` fields |
| 3: Authentication fields | `Authentication-Results:`, `Received-SPF:`, `DKIM-Signature:`, `ARC-Authentication-Results:`, `ARC-Message-Signature:`, `ARC-Seal:` |
| 4: MIME and attachments | `MIME-Version:`, `Content-Type:`, `Content-Transfer-Encoding:`, `Content-Disposition:`, `Content-ID:`, `Content-Description:`, `Content-Language:`, `charset=`, `boundary=`, `name=`, `filename=`, extended parameter forms |
| 5: Lists and client metadata | `List-ID:`, `List-Unsubscribe:`, `List-Unsubscribe-Post:`, `List-Help:`, `List-Subscribe:`, `List-Post:`, `List-Owner:`, `List-Archive:`, `User-Agent:`, `X-Mailer:`, `Thread-Topic:`, `Thread-Index:`, `Importance:`, `X-Priority:` |
| 6: Vendor filtering fields | `X-Forefront-Antispam-Report:`, `X-Microsoft-Antispam:`, `X-MS-Exchange-Organization-SCL:`, plus vendor fields backed by public documentation and representative samples |
| 7: Authentication methods and properties | `spf=`, `dkim=`, `dmarc=`, `arc=`, `compauth=`, `smtp.mailfrom=`, `smtp.helo=`, `header.from=`, `header.d=`, `header.s=`, `header.i=` |
| 8: Results and diagnostic keys | `pass`, `fail`, `softfail`, `neutral`, `none`, `temperror`, `permerror`, `policy`; Microsoft keys such as `SCL:`, `BCL:`, `CIP:`, `CAT:`, `SFV:`, `DIR:` |

Preserve useful V1 fields outside these examples. Not every message contains every field; provider-specific fields vary. Avoid assigning security severity to the field-name colors.

Core field source: [RFC 5322](https://www.rfc-editor.org/rfc/rfc5322.html). Authentication source: [RFC 8601](https://www.rfc-editor.org/rfc/rfc8601.html). ARC source: [RFC 8617](https://www.rfc-editor.org/rfc/rfc8617.html). MIME sources: [RFC 2045](https://www.rfc-editor.org/rfc/rfc2045.html), [RFC 2183](https://www.rfc-editor.org/rfc/rfc2183.html), [RFC 2231](https://www.rfc-editor.org/rfc/rfc2231.html). List sources: [RFC 2369](https://www.rfc-editor.org/rfc/rfc2369.html), [RFC 2919](https://www.rfc-editor.org/rfc/rfc2919.html), [RFC 8058](https://www.rfc-editor.org/rfc/rfc8058.html). Microsoft fields: [anti-spam message headers](https://learn.microsoft.com/en-us/defender-office-365/message-headers-eop-mdo).

## Value highlighting and limitations

- Retain separate styling for angle-bracketed identifiers, parenthesized comments, and encoded words. Test quotes and escaping before expanding delimiter rules.
- Review DKIM/ARC tags (`a=`, `d=`, `s=`, `h=`, `bh=`, `b=`, `i=`, `cv=`) in sample data; short tags must not turn unrelated text into authentication highlighting.
- IP addresses, hostnames, URLs, and timestamps are useful analysis targets. UDL token and delimiter rules cannot promise accurate arbitrary-pattern recognition. Do not claim regex-based validation.
- A displayed authentication result is a recorded assertion, not a verification performed by this UDL. `pass` must not imply that the whole message is safe. Result colors should remain neutral until reliable context-specific matching is demonstrated.
- Test CRLF and LF, folded lines, mixed case, repeated Received/ARC fields, header-like body text, and missing or unmatched delimiters. UDL does not understand the header/body boundary.
- Test both themes with synthetic examples and identical matching rules before calling any V2 definition supported.
