# Usage:
#  In your .bashrc or .zshrc, source this file as follows:
#
#  ```
#  export ALIASES_SCRIPT_PATH=<local path to this script>
#  source $ALIASES_SCRIPT_PATH
#  ```

################
# Git Commands #
################

## Commit
gcm() {
  git commit -m $@
}

## Pull
gp() {
  git pull $@
}

## Pull Origin
gpo() {
  git pull origin $@
}

## Push
gpsh() {
  git push $@
}

## Publish
gpbl() {
  git push --set-upstream $1 "$(git rev-parse --abbrev-ref HEAD)" ${@:2}
}

## Publish
gpblo() {
  gpbl origin $@
}

## Checkout
gco() {
  git checkout $@
}

## Checkout New
gcb() {
  git checkout -b $@
}

## Add
ga() {
  git add $@
}

## Add All
gaa() {
  git add . $@
}

####################
# Generic Commands #
####################

## Run comman once with each arg string
## e.g.
##  $ wargs "npm run" test "build -- --release"
##
## Is equivalent to:
##  $ npm run test && npm run build -- --release
wargs() {(
  for var in ${@:2}
  do
    $(echo $1 $var)
    exit_status=$?
    if [ ${exit_status} -ne 0 ]; then
      exit "${exit_status}"
    fi
  done
)}

################
# NPM Commands #
################

## Run npm command
npmr() {
  npm run $@
}

## Run many npm commands
## e.g.
##  $ npmm format lint test "build -- --release"
##
## Is equivalent to:
##  $ npm run format && npm run lint && npm run test && npm run build -- --release
npmm() {(
  wargs "npm run" $@
)}

#######################
# Navigation Commands #
#######################

## List entries in long format
ll() {
  ls -l $@
}

## List all entries
la() {
  ls -a $@
}

## List all entries in long format
lla() {
  ls -la $@
}

## Change directory and run
cdr() {
  cd $1 && ${@:2}
}

## Change directory and list entries
cdl() {
  cdr $1 ls ${@:2}
}

## Change directory and list entries in long format
cdll() {
  cdr $1 ll ${@:2}
}

## Change directory and list all entries
cdla() {
  cdr $1 la ${@:2}
}

## Change directory and list all entries in long format
cdlla() {
  cdr $1 lla ${@:2}
}

########
# Help #
########

help() {
  echo "Git Commands"
  echo "  gcm  - Commit"
  echo "  gp   - Pull"
  echo "  gpo  - Pull Origin"
  echo "  gpsh - Push"
  echo "  gpbl - Publish"
  echo "  gpblo- Publish Origin"
  echo "  gco  - Checkout"
  echo "  gcb  - Checkout New"
  echo "  ga   - Add"
  echo "  gaa  - Add All"
  echo ""
  echo "Generic Commands"
  echo "  wargs - Run command once with each arg string"
  echo ""
  echo "NPM Commands"
  echo "  npmr  - Run npm command"
  echo "  npmm  - Run many npm commands"
  echo ""
  echo "Navigation Commands"
  echo "  ll    - List entries in long format"
  echo "  la    - List all entries"
  echo "  lla   - List all entries in long format"
  echo "  cdr   - Change directory and run"
  echo "  cdl   - Change directory and list entries"
  echo "  cdll  - Change directory and list entries in long format"
  echo "  cdla  - Change directory and list all entries"
  echo "  cdlla - Change directory and list all entries in long format"
  echo ""
  echo "ALIASES_SCRIPT_PATH=$ALIASES_SCRIPT_PATH"
}
