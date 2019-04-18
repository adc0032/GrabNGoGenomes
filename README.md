Prerequisites:  Entrez E-Utilites (some systems may need to separately download Xtract), Perl, and SRA Toolkit

```
#My non-student ASC account gave me an error saying I need to run these commands to use xtract. These then require that "xtract" be replaced with "xtract.Linux"
ftp-cp ftp.ncbi.nlm.nih.gov /entrez/entrezdirect xtract.Linux.gz
gunzip -f xtract.Linux.gz
chmod +x xtract.Linux
```
