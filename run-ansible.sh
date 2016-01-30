#/bin/bash
stdbuf -o0 ansible-playbook /vagrant/ansible-playbook.yml -c local -i localhost, | tee /tmp/ansible.log
