PATH=$PATH:~/bin
export GOPATH=$HOME/go_hm
export GOROOT=/usr/local/opt/go/libexec

alias chrome="open -a 'Google Chrome'"
alias ls='ls -Ghp'
alias mv='mv -i'
alias cp='cp -i'
alias g='git'
alias t='task'
alias diff='colordiff'

# Update title of terminal tab to reflect current directory. 
PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"'

txtblk='\e[0;30m' # Black - Regular
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green
txtylw='\e[0;33m' # Yellow
txtblu='\e[0;34m' # Blue
txtpur='\e[0;35m' # Purple
txtcyn='\e[0;36m' # Cyan
txtwht='\e[0;37m' # White
bldblk='\e[1;30m' # Black - Bold
bldred='\e[1;31m' # Red
bldgrn='\e[1;32m' # Green
bldylw='\e[1;33m' # Yellow
bldblu='\e[1;34m' # Blue
bldpur='\e[1;35m' # Purple
bldcyn='\e[1;36m' # Cyan
bldwht='\e[1;37m' # White
unkblk='\e[4;30m' # Black - Underline
undred='\e[4;31m' # Red
undgrn='\e[4;32m' # Green
undylw='\e[4;33m' # Yellow
undblu='\e[4;34m' # Blue
undpur='\e[4;35m' # Purple
undcyn='\e[4;36m' # Cyan
undwht='\e[4;37m' # White
bakblk='\e[40m'   # Black - Background
bakred='\e[41m'   # Red
badgrn='\e[42m'   # Green
bakylw='\e[43m'   # Yellow
bakblu='\e[44m'   # Blue
bakpur='\e[45m'   # Purple
bakcyn='\e[46m'   # Cyan
bakwht='\e[47m'   # White
txtrst='\e[0m'    # Text Reset - Useful for avoiding color bleed

export PS1="\[$bldblu\]\u@\h \[$bldgrn\]\w\[$txtblu\]\$(parse_git_branch) $ \[$txtrst\]"

# Use `config` command like `git` to help deal with bare repo ~/dotfiles. 
alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'

# Allow vim bindings in bash. Use "shopt -os vi" to unset.
set -o vi

###########
# Functions
###########

# Display git branch in prompt when in a repo.
parse_git_branch() {
	git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

kill_port() {
        # To close default ssh to remote jupyter started from `connect_jupyter`: kill_port 8000
        lsof -ti:${1:-8000} | xargs kill
}

start_jupyter() {
        # Run from ec2 to start headless Jupyter. Outputs ip address and jupyter auth token. You can copy this
        # output, then run `connect_jupyter cmd-v` locally to connect.
        nohup jupyter notebook --no-browser > /dev/null 2>&1 &
        ip=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
        sleep 1
        token=$(jupyter notebook list | grep -oP '(?<=token=)[\w\d]*')
        echo "${ip} ${token}"
}

connect_jupyter() {
        # First argument is ec2 IP address, second argument is jupyter token.
        # This is the string output by `start_jupyter` on ec2.
        ssh -i ~/.ssh/gg_rsa -N -f -L 8000:localhost:8888 ubuntu@$1
        echo localhost:8000/tree/?token=$2
}

enable_jupyter_extensions() {
        # Install and enable Harrison's preferred jupyter extensions.
        pip install jupyter_contrib_nbextensions
        jupyter contrib nbextension install --user
        jupyter nbextension enable execute_time/ExecuteTime
        jupyter nbextension enable ruler/main
        jupyter nbextension enable spellchecker/main
        jupyter nbextension enable toc2/main
        jupyter nbextension enable python-markdown/main
        jupyter nbextension enable --py widgetsnbextension
}

install_pyenv() {
        # Install pyenv. Seems like .bashrc needs to be sourced every time I connect to ec2 though.
        sudo apt-get update && sudo apt-get upgrade
        sudo apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev \
                libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev git
        curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
        echo 'export PATH="~/.pyenv/bin:$PATH"' >> ~/.bashrc
        echo 'eval "$(pyenv init -)"' >> ~/.bashrc
        echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
        source ~/.bashrc
}

fetch_dotfiles() {
        # Fetch Harrison's dotfiles and configure tracking.
        echo "alias config='/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME'" >> ~/.bashrc
        source ~/.bashrc
        echo "dotfiles" >> .gitignore
        git clone --bare git@github.com:hdmamin/dotfiles.git $HOME/dotfiles/
        config checkout
        config config --local status.showUntrackedFiles no
        # Download vim plugin manager (necessary for .vimrc to work correctly).
        curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

