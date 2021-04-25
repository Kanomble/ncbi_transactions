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

## E-Direct
EDirect search commands for symbiosis, EPS and organismic interactions. Search field and tags for pubmed are listed [here](https://pubmed.ncbi.nlm.nih.gov/help/#search-tags).
````Shell
esearch -db pubmed -query "EPS membrane formation" | elink -target protein | efilter -organism curvibacter | efetch -format fasta > curvibacter_eps_proteins.faa

esearch -db pubmed -query "genes involved in symbiosis" | efetch format abstract > abstracts_genes_involved_in_symbiosis.list.txt

esearch -db pubmed -query "genes involved in symbiosis" | elink -target protein | efilter -organism curvibacter | efetch -format fasta > curvibacter_symbiosis_gene_candidates.faa

esearch -db pubmed -query "organismic interactions" | elink -target protein | efilter -organism eubacteria | efetch -format fasta > eubacteria_organismic_interactions.faa
````
More advanced filtering
````Shell
esearch -db pubmed -query "symbiosis [MAJR] OR organismic interactions [MAJR] AND NOT plants [MAJR] AND review [PT]" | efetch -format docsum | xtract -pattern DocumentSummary -sep '\t' -element Id PubDate Source Author Title ELocationID > symbiosis_org_int_reviews.txt
````
