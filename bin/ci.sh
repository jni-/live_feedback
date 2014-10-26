#!/bin/bash - 
#===============================================================================
#
#          FILE:  ci.sh
# 
#         USAGE:  ./ci.sh 
# 
#   DESCRIPTION:  
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR: YOUR NAME (), 
#       COMPANY: 
#       CREATED: 25/10/14 10:50:29 AM EDT
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

# Bash sucks at figuring itself out. Finds this script's directory. From : http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR_SELF="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
DIR="$DIR_SELF/../src"

FAILING=false
command -v notify-send > /dev/null && NOTIFY='notify-send -a LiveFeedback -t 2000 -u' || NOTIFY='echo'

inotifywait -mr --timefmt '%d/%m/%y %H:%M' --format '%T %w %f' --exclude '.*\.swp' -e modify "$DIR/config" "$DIR/mix.exs" "$DIR/lib" "$DIR/test" "$DIR/web" | while read date time dir file; do
  FILECHANGE=${dir}${file}
  echo "At ${time} on ${date}, file $FILECHANGE"


  /bin/bash $DIR_SELF/test.sh quick
  if [[ "$?" -ne "0" ]]; then
    FAILING=true
    $NOTIFY "critical" "Test Failure" 'You broke something again!!'
  else
    if $FAILING; then
      $NOTIFY "normal" "Everything back to normal" "You are awesome"
    fi
    FAILING=false
  fi
done

