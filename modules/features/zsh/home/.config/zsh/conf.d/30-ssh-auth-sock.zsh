# Works in conjunction with ~/.ssh/rc, which creates link from ~/.ssh/ssh_auth_sock
if [ -S ~/.ssh/ssh_auth_sock ]; then
  export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
fi
