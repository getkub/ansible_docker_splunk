set -ev
set -o pipefail

# Grab the parent (root) directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
ME=`basename "$0"`

cd ${DIR}/ansible
echo ${ME} `date`  PWD=${DIR}

ansible-playbook -i hosts -c local site.yml

