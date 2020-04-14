# Felix' Fish Configuration.


# Import a .profile file if it exists.
# This requires fish-foreign-env (a nix package) to interpret
# bash commands, and can be used to get nix into the PATH.
function import-dot-profile
  set fenv_path /Users/felix/.nix-profile/share/fish-foreign-env/functions
  set fish_function_path $fenv_path $fish_function_path
  fenv source $HOME/.profile > /dev/null
end
if test -e ~/.profile; import-dot-profile; end


# Add Emacs Directly to Path in MacOS
if test (uname) = "Darwin"
  export PATH="/usr/local/Cellar/emacs-mac/emacs-26.1-z-mac-7.4/bin/:$PATH"
end


# Better Greeting.
function fish_greeting
    begin
        echo (date) " @ " (hostname)
        echo
        fortune -a
        echo
    end | lolcat
end


# Use Powerline as prompt (requires patched fonts).
function fish_prompt
    powerline-go \
    -error $status -shell bare -cwd-mode plain -numeric-exit-codes \
    -modules "venv,ssh,cwd,git,jobs,exit"
end



# Nvim.
set -U EDITOR 'nvim'
alias vi='nvim'
alias view='nvim -R'

# Emacs.
alias e='emacsclient --no-wait --quiet --alternate-editor="nvim"'

# Exa.
alias ls='exa';
alias l='exa -l --git';
alias la='exa -l -a --git';
alias l2='exa -l --git -T --level 2';

# Hide copyright/intro
alias gdb='gdb -q'
alias julia='julia --banner=no'
alias calc='calc -d'

# Misc.
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC'
alias mylint='pylint --rcfile=~/.dotfiles/python/pylint.rc'
alias ca='command --all'



function zshsearch -d "Search through zsh history"
    command awk --field-separator=';' '/'$argv'/{$1=""; print}' ~/.zsh_history
end


function awaketime -d "Display time since last waking."
    echo "Awake Since " \
    (pmset -g log | awk -e '/ Wake  /{print $2}' | tail -n 1)
end


function gitlog -d "More detailed, prettified output for git."
    git log --graph --abbrev-commit \
    --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"
end


function ghci-nix -d "Nix shell with haskell and packages."
    set PCKS ""
    for s in $argv
        set PCKS "$s $PCKS"
    end
    nix-shell -p "haskellPackages.ghcWithPackages (ps: with ps; [ $PCKS ])" \
    --command ghci
end


function ranger-cd                                                               
  set tempfile '/tmp/chosendir'                                                  
  ranger --choosedir=$tempfile (pwd)                                    

  if test -f $tempfile                                                           
      if [ (cat $tempfile) != (pwd) ]                                            
        cd (cat $tempfile)                                                       
      end                                                                        
  end                                                                            

  rm -f $tempfile                                                                

end                                                                              

function fish_user_key_bindings                                                  
    bind \co 'ranger-cd ; fish_prompt'                                           
end

alias r='ranger-cd'
alias cimmaronip="nmap -sL 192.168.1.0/24 | grep cimarron | sed -E 's/.*\((.+)\)/\1/'"
