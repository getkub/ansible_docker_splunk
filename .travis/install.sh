# Exit on first error, print all commands.
set -ev
set -o pipefail

# Grab the parent (root) directory.
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"
ME=`basename "$0"`

echo ${ME} `date`

cd ${DIR}/ansible
ansible-playbook -i hosts -c local site.yml --tags "docker_splunk_clean"

