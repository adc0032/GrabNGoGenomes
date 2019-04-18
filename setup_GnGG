!#/bin/bash

#Downloads Entrez E-Utilities

cd ~
  /bin/bash
  perl -MNet::FTP -e \
    '$ftp = new Net::FTP("ftp.ncbi.nlm.nih.gov", Passive => 1);
     $ftp->login; $ftp->binary;
     $ftp->get("/entrez/entrezdirect/edirect.tar.gz");'
  gunzip -c edirect.tar.gz | tar xf -
  rm edirect.tar.gz
  builtin exit
  export PATH=${PATH}:$HOME/edirect >& /dev/null || setenv PATH "${PATH}:$HOME/edirect"
  ./edirect/setup.sh

#Puts Entrez in $PATH
echo "export PATH=\$PATH:\$HOME/edirect" >> $HOME/.bash_profile

echo "export PATH=\$PATH:\$HOME/edirect" >> $HOME/.bashrc
