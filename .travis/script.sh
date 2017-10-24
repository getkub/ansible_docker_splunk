set -ev
set -o pipefail

# Grab the parent (root) directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
ME=`basename "$0"`

cd ${DIR}
echo ${ME} `date`  PWD=${DIR}

# make clean
make build
