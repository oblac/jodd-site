set -e

e_header "Update Jodd site"

e_arrow "Build"

bundle exec nanoc compile
bundle exec nanoc sd

e_arrow "Sync"

cd output
zsh ~/bin/sync-site.zsh jodd $1

e_success "Done."