$ErrorActionPreference = 'Stop'
# Both variants are generated from the same rules; V1 remains the historical baseline.
$groups = @(
    'Received: Return-Path: Delivered-To: X-Original-To: Envelope-To: Delivery-Date:',
    'From: Sender: Reply-To: To: Cc: Bcc: Date: Subject: Message-ID: In-Reply-To: References: Resent-Date: Resent-From: Resent-Sender: Resent-To: Resent-Cc: Resent-Bcc: Resent-Message-ID: Resent-Reply-To: Original-From: Original-Sender: Original-Subject: Original-Message-ID:',
    'Authentication-Results: Authentication-Results-Original: Received-SPF: DKIM-Signature: ARC-Authentication-Results: ARC-Message-Signature: ARC-Seal:',
    'MIME-Version: Content-Type: Content-Transfer-Encoding: Content-Disposition: Content-ID: Content-Description: Content-Language: Content-MD5: Content-Location: Content-Length:',
    'List-ID: List-Unsubscribe: List-Unsubscribe-Post: List-Help: List-Subscribe: List-Post: List-Owner: List-Archive: User-Agent: X-Mailer: Thread-Topic: Thread-Index: Importance: Priority: X-Priority: Feedback-ID: Accept-Language: Keywords: Comments: Organization: Precedence: Errors-To: Auto-Submitted: Disposition-Notification-To: Return-Receipt-To:',
    'X-Forefront-Antispam-Report: X-Forefront-Antispam-Report-Untrusted: X-Microsoft-Antispam: X-Microsoft-Antispam-Message-Info: X-MS-Exchange-Organization-SCL: X-MS-Exchange-Organization-AuthAs: X-MS-Exchange-Organization-AuthSource:',
    'spf= dkim= dmarc= arc= compauth= smtp.mailfrom= smtp.helo= header.from= header.d= header.s= header.i= charset= boundary= filename= filename*= name= name*= SCL: BCL: CIP: CAT: SFV: DIR:',
    'pass fail softfail neutral none temperror permerror policy base64 quoted-printable 7bit 8bit binary attachment inline'
)
foreach ($variant in @('Light','Dark')) {
    $source = if ($variant -eq 'Light') { '01-npp-email-header-light-socmanager.com-v1.xml' } else { '02-npp-email-header-dark-socmanager.com-v1.xml' }
    [xml]$doc = Get-Content -LiteralPath (Join-Path $PSScriptRoot $source) -Raw
    $lang = $doc.NotepadPlus.UserLang
    $lang.SetAttribute('name', "Email Header $variant - SocManager.com - V2")
    # Light owns automatic associations; Dark remains manually selectable.
    $lang.SetAttribute('ext', $(if ($variant -eq 'Light') {'eml emlx mbox'} else {''}))
    # Retain the V1 custom-field-to-colon mechanism, restricted to column one.
    $lang.Settings.Global.SetAttribute('forcePureLC', '1')
    foreach ($node in $lang.KeywordLists.Keywords) {
        if ($node.name -match '^Keywords([1-8])$') {
            $number = [int]$Matches[1]
            $node.InnerText = $groups[$number - 1]
            # Parameter values are part of the token highlighted in prefix mode.
            $lang.Settings.Prefix.SetAttribute("Keywords$number", $(if ($number -eq 7) {'yes'} else {'no'}))
        }
    }
    # Map expanded categories onto the original variant's colors and emphasis.
    $originalStyles = @{}
    foreach ($style in $lang.Styles.WordsStyle) { $originalStyles[$style.name] = $style.CloneNode($true) }
    $categoryStyles = @('KEYWORDS1','KEYWORDS2','KEYWORDS1','KEYWORDS2','KEYWORDS3','LINE COMMENTS','KEYWORDS2','DEFAULT')
    foreach ($style in $lang.Styles.WordsStyle) {
        if ($style.name -match '^KEYWORDS([1-8])$') {
            $original = $originalStyles[$categoryStyles[[int]$Matches[1] - 1]]
            foreach ($attribute in @('fgColor','bgColor','colorStyle','fontStyle')) {
                $style.SetAttribute($attribute, $original.GetAttribute($attribute))
            }
        }
        # A palette must not inherit an incompatible editor background.
        $style.SetAttribute('bgColor', $(if ($variant -eq 'Light') {'FFFFFF'} else {'202020'}))
        $style.SetAttribute('colorStyle', '3')
    }
    $declaration = $doc.CreateXmlDeclaration('1.0','UTF-8',$null)
    [void]$doc.InsertBefore($declaration, $doc.DocumentElement)
    $settings = New-Object System.Xml.XmlWriterSettings
    $settings.Encoding = New-Object System.Text.UTF8Encoding($false)
    $settings.Indent = $true
    $path = Join-Path $PSScriptRoot "EmailHeader_SocManager_${variant}_v2.xml"
    $writer = [System.Xml.XmlWriter]::Create($path, $settings)
    try { $doc.Save($writer) } finally { $writer.Dispose() }
}
