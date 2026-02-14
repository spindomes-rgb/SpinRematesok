$configHeader = @"
const CONFIG = {
    whatsappNumber: "56982622961",
    storeName: "SpinRemates",
    currency: "$",
};

const ITEMS = [
"@

$items = @()

# FIGURAS MDF
$mdfFiles = Get-ChildItem "Figuras Mdf" -File
foreach ($file in $mdfFiles) {
    if ($file.Extension -match "jpg|jpeg|png") {
        $name = $file.BaseName
        $width = "???"
        $height = "???"
        $priceInFile = 0
        
        # Pattern: "Name {size} cm $ {price}"
        if ($name -match "(.+?)\s+(\d+)\s*cm\s*\$\s*([\d\.\s]+)") {
            $name = $Matches[1].Trim()
            $width = $Matches[2] + " cm"
            $height = $Matches[2] + " cm"
            $priceInFile = $Matches[3].Replace(".", "").Replace(" ", "") -as [int]
        }
        
        $originalPrice = $priceInFile
        if ($originalPrice -eq 0) { $originalPrice = 10000 }
        
        $salePrice = [Math]::Round($originalPrice * 0.7) # 30% discount

        $items += "    {
        id: `"fig-$(($items.Count + 1).ToString().PadLeft(3, '0'))`",
        category: `"mdf`",
        name: `"$name`",
        image: `"Figuras Mdf/$($file.Name)`",
        description: `"Figura decorativa en MDF.`",
        originalPrice: $originalPrice,
        salePrice: $salePrice,
        width: `"$width`",
        height: `"$height`",
        sold: false
    }"
    }
}

# TELAS SUBLIMADAS
$telasFiles = Get-ChildItem "Telas Sublimadas" -File
foreach ($file in $telasFiles) {
    if ($file.Extension -match "jpg|jpeg|png") {
        $name = $file.BaseName
        $width = "???"
        $height = "???"
        $priceInFile = 10000 # NEW DEFAULT: 10000
        
        # Try to match price in filename if it exists: "Name ... $ {price}"
        if ($name -match "\$\s*([\d\.\s]+)") {
            $priceInFile = $Matches[1].Replace(".", "").Replace(" ", "") -as [int]
        }

        # Pattern for size: "Name {W}x{H}"
        if ($name -match "(\d+)x(\d+)") {
            $width = $Matches[1] + " cm"
            $height = $Matches[2] + " cm"
        }
        
        # Clean name (remove price and size from title)
        $cleanName = $name -replace "\d+x\d+", "" -replace "\$\s*[\d\.\s]+", "" -replace "lateral", ""
        $cleanName = $cleanName.Trim()

        $originalPrice = $priceInFile
        $salePrice = [Math]::Round($originalPrice * 0.7) # 30% discount

        $items += "    {
        id: `"tela-$(($items.Count + 1).ToString().PadLeft(3, '0'))`",
        category: `"telas`",
        name: `"$cleanName`",
        image: `"Telas Sublimadas/$($file.Name)`",
        description: `"Tela sublimada premium.`",
        originalPrice: $originalPrice,
        salePrice: $salePrice,
        width: `"$width`",
        height: `"$height`",
        sold: false
    }"
    }
}

$footer = "];"
$finalContent = $configHeader + "`n" + ($items -join ",`n") + "`n" + $footer
$finalContent | Out-File -FilePath "data.js" -Encoding utf8
Write-Host "data.js has been updated. Telas now default to 10k (applied 30% discount)."
