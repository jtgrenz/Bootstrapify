# Ruby and Ruby Gems setup

default_ruby='2.2.1'

export Gems='
  shopify_theme
  bundler
'

echo "$FORMAT #### Installing Ruby"
  rbenv install $default_ruby
  rbenv global $default_ruby


for gem in $Gems
do
  tmp=`gem list | grep $gem`
  if [[ ! $tmp ]]; then
    echo ''
    echo "$FORMAT ##### Installing $RED $gem ..."
    gem install $gem
  fi
done

