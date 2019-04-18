Prerequisites:  Entrez E-Utilites (some systems may need to separately download Xtract), Perl, and SRA Toolkit

```
The xtract command present in the get_SeqRec.sh script should be included in the edirect download. However, if you are receiving an error claiming you do not have xtract
then try using the following commands to download xtract:

ftp-cp ftp.ncbi.nlm.nih.gov /entrez/entrezdirect xtract.Linux.gz
gunzip -f xtract.Linux.gz
chmod +x xtract.Linux
```
After this, replace the xtract command anywhere in the get_SeqRec.sh script with xtract.Linux and this should solve the issue.
