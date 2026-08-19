//BackEnd
function Show-Tree {
    param(
        [string]$Path = ".",
        [string]$Indent = ""
    )

    $exclude = @(
        ".git",
        ".vs",
        "bin",
        "obj",
        "frontend",
        "PasswordGenerator",
        "node_modules"
    )

    $items = Get-ChildItem -Path $Path |
        Where-Object { $exclude -notcontains $_.Name } |
        Sort-Object @{Expression={$_.PSIsContainer};Descending=$true}, Name

    foreach ($item in $items) {
        Write-Output "$Indent|-- $($item.Name)"

        if ($item.PSIsContainer) {
            Show-Tree -Path $item.FullName -Indent "$Indent|   "
        }
    }
}

Show-Tree

//FrontEnd
tree .\src /F /A