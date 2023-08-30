# convenience-scripts
dependencies:
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [bat](https://github.com/sharkdp/bat)
- [fzf](https://github.com/junegunn/fzf)
## setup on pop
1. install the dependencies
   * `sudo apt install fzf bat ripgrep`
1. make a local bin if you dont have one
   * `[ -d ~/.local/bin ] || mkdir -p ~/.local/bin`
1. copy scripts to the local bin, I prefer renaming them
   * `cp fzf-preview.sh ~/.local/bin/pv`
   * `cp interactive-rg.sh ~/.local/bin/gs`
1. make them executable
   * `chmod +x ~/.local/bin/*`
1. try them in your projects directory
