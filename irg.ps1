# Define a function that uses `rg` and `fzf` to search and select a file and line number
function Select-FileAndLine {
    param (
        [string]$SearchTerm = ""
    )

    # Use `rg` (ripgrep) to search for the term, then pipe to `fzf` for interactive selection
    $result = rg --color=always --line-number --no-heading --smart-case $SearchTerm |
        fzf --ansi `
            --color "hl:-1:underline,hl+:-1:underline:reverse" `
            --delimiter : `
            --preview 'bat --color=always {1} --highlight-line {2}' `
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3'

    return $result
}

# Run the function and split the result into file and line number
$SearchTerm = if ($args.Count -gt 0) { $args -join " " } else { "" }
$result = Select-FileAndLine -SearchTerm $SearchTerm
if ($result) {
    $parts = $result -split ':'
    $file = $parts[0]
    $line = $parts[1]

    # Open the file in Vim at the specific line
    notepad "$file" +$line
}
