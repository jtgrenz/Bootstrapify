# NPM install setup


export NPM='
  grunt-cli
  gulp
'

for app in $NPM
do
  tmp=`npm list -g | grep $app`
  if [[ ! $tmp ]]; then
    echo ''
    echo '##### Installing '$app'...'
    npm install $app -g
  fi
done

