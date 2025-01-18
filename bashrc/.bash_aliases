# Init ssh session with onos controller
alias ssh-onos='ssh -p 8101 -o StrictHostKeyChecking=no karaf@localhost'
alias ssh-onos-lab='ssh -p 8101 -o StrictHostKeyChecking=no karaf@10.0.22.157'
alias onos='~/Tese/scripts/ssh-onos.sh'

alias apus_tmux='~/Tese/scripts/apus_tmux.sh'

alias dual='/home/hugo/monitor-script.sh "dual"'
alias dual-hdmi='/home/hugo/monitor-script.sh "dual-hdmi"'
alias dual-razer='/home/hugo/monitor-script.sh "dual-razer"'
alias dual-msi='/home/hugo/monitor-script.sh "dual-msi"'

alias fzf='fzf --preview="batcat --color=always {}"'
alias f='nvim $(fzf --preview="batcat --color=always {}")'

alias tu='sudo tailscale up --accept-routes'
alias td='sudo tailscale down'

alias brain='open "obsidian://open?vault=2brain" >/dev/null 2>&1'
