# ncbi_transactions
Functional interfaces for transactions with NCBI databases. Download the refseq assembly summary file and parse the data into a pandas dataframe. Translate higher taxonomic nodes (e.g. Eubacteria - 2) into species level taxonomic nodes with the [E-Direct](https://www.ncbi.nlm.nih.gov/books/NBK179288/) tool. Filter entries in the assembly summary file with species level taxonomic nodes or limit BLAST searches with the option `taxidlist`. Download assemblies with the `wget` library, decompress `.gz` files by simultaneous creation of an taxmap file that can be used by `makeblastdb`.

## snakemake
[Snakemake](https://snakemake.readthedocs.io/en/stable/index.html) can be used to manage workflow processes.

## Quick Installation
Docker is used for the installation of required software.
```console
docker build -t pythonblast:1.0 .
docker run -dt --name pythonblast_jupyter -v ${PWD}:/blast/applications pythonblast:1.0
```
After container creation run: `docker exec -it pythonblast_juptyer /bin/sh` and activate the [E-Direct](https://www.ncbi.nlm.nih.gov/books/NBK179288/) executables with:
```console
cd ../edirect
./setup.sh -y
get_species_taxids.sh -t 9606
```

If everything is set successfully you should see this output in the container terminal:
9606
63221
741158.
