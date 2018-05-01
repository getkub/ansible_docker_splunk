# Grab the parent (root) directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
ME=`basename "$0"`

echo ${ME} `date`

cd ${DIR}
echo "Inside Directory: ${DIR}"
ls -l 
make deploy
