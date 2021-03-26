# ncbi_transactions
Functional interfaces for transactions with NCBI databases. Download the refseq assembly summary file and parse the data into a pandas dataframe. Translate higher taxonomic nodes (e.g. Eubacteria - 2) into species level taxonomic nodes with the (E-Direct)[https://www.ncbi.nlm.nih.gov/books/NBK179288/] tool. Filter entries in the assembly summary file with species level taxonomic nodes or limit BLAST searches with the option `taxidlist`. Download assemblies with the `wget` library, decompress `.gz` files by simultaneous creation of an taxmap file that can be used by `makeblastdb`.

## Quick Installation
Docker is used for the installation of required software.
```console
docker build -t pythonblast:1.0 .
docker run -dt -v ${PWD}:/blast/applications pythonblast:1.0
```
