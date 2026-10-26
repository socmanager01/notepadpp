$ErrorActionPreference = 'Stop'
$definitions = @()
foreach ($variant in @('Light','Dark')) {
    $path = Join-Path $PSScriptRoot "EmailHeader_SocManager_${variant}_v2.xml"
    $raw = Get-Content -LiteralPath $path -Raw
    if ($raw -notmatch '^<\?xml version="1.0" encoding="utf-8"\?>') { throw "Missing UTF-8 declaration: $path" }
    [xml]$doc = $raw
    $lang = $doc.NotepadPlus.UserLang
    $expectedExtensions = if ($variant -eq 'Light') {'eml emlx mbox'} else {''}
    if ($lang.ext -ne $expectedExtensions -or $lang.udlVersion -ne '2.1') { throw 'Unexpected association or UDL version' }
    $tokens = @{}
    foreach ($node in $lang.KeywordLists.Keywords) {
        if ($node.name -match '^Keywords[1-8]$') {
            foreach ($token in ($node.InnerText -split '\s+')) {
                if ($tokens.ContainsKey($token)) { throw "Duplicate keyword: $token" }
                $tokens[$token] = $true
            }
        }
    }
    foreach ($required in @('Received:','From:','Reply-To:','ARC-Seal:','ARC-Authentication-Results:','Content-Disposition:','List-Unsubscribe-Post:','spf=','dmarc=','filename=','X-Forefront-Antispam-Report:')) {
        if (-not $tokens.ContainsKey($required)) { throw "Missing coverage: $required" }
    }
    $definitions += $lang
    $background = if ($variant -eq 'Light') { 'FFFFFF' } else { '202020' }
    foreach ($style in $lang.Styles.WordsStyle) {
        if ($style.bgColor -ne $background -or $style.colorStyle -ne '3') {
            throw "Missing explicit palette background: $variant $($style.name)"
        }
        if ($style.fgColor -eq $background) { throw "Invisible text: $variant $($style.name)" }
    }
    $defaultStyle = $lang.Styles.WordsStyle | Where-Object name -eq 'DEFAULT'
    $expectedForeground = if ($variant -eq 'Light') { '000000' } else { 'FFFFFF' }
    if ($defaultStyle.fgColor -ne $expectedForeground) { throw "Unexpected default foreground: $variant" }
    Write-Output "$variant`: XML valid; $($tokens.Count) unique keywords"
}
if ($definitions[0].KeywordLists.OuterXml -cne $definitions[1].KeywordLists.OuterXml -or $definitions[0].Settings.OuterXml -cne $definitions[1].Settings.OuterXml) { throw 'Variant matching rules differ' }
Write-Output 'Light/Dark rule parity verified. Rendering and lexer behavior still require Notepad++ checks.'
