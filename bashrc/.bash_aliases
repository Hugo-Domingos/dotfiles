# Init ssh session with onos controller
alias ssh-onos='ssh -p 8101 -o StrictHostKeyChecking=no karaf@localhost'
alias ssh-onos-lab='ssh -p 8101 -o StrictHostKeyChecking=no karaf@10.0.22.157'
alias onos='~/Tese/scripts/ssh-onos.sh'

alias apus_tmux='~/Tese/scripts/apus_tmux.sh'
alias dev='~/Tese/scripts/tmux-onos-dev.sh'

alias dual='/home/hugo/monitor-script.sh "dual"'
alias dual-hdmi='/home/hugo/monitor-script.sh "dual-hdmi"'
alias dual-razer='/home/hugo/monitor-script.sh "dual-razer"'
alias dual-msi='/home/hugo/monitor-script.sh "dual-msi"'

alias fzf='fzf --preview="batcat --color=always {}"'
alias f='nvim $(fzf --preview="batcat --color=always {}")'

alias tu='sudo tailscale up --accept-routes'
alias td='sudo tailscale down'

alias dns='sudo bash ~/cp-dns.sh'

alias picador='ssh nap@10.0.22.217'

alias dev='bash ~/Tese/scripts/tmux-onos-dev.sh'

alias 215='ssh nap@10.0.23.236'
alias 117='ssh nap@10.0.23.150'
alias 111='ssh nap@10.0.23.109'
alias 100='ssh nap@10.0.23.141'
alias vm='ssh nap@10.0.22.118'

alias mqtt='open -n -a "MQTT Explorer"'
