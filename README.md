# TODO
- [ ] Update Dockerfile - currently entrez installation won't work due to changed ftp repository
- [ ] Put example csvs into data folder

# ncbi_transactions
Functional interfaces for transactions with NCBI databases. Download the refseq assembly summary file and parse the data into a pandas dataframe. Translate higher taxonomic nodes (e.g. Eubacteria - 2) into species level taxonomic nodes with the [E-Direct](https://www.ncbi.nlm.nih.gov/books/NBK179288/) tool. Filter entries in the assembly summary file with species level taxonomic nodes or limit BLAST searches with the option `taxidlist`. Download assemblies with the `wget` library, decompress `.gz` files by simultaneous creation of an taxmap file that can be used by `makeblastdb`.

If you can't access your jupyter notebook due to missing token or password open a terminal and submit following commands:
```console
docker exec -it pythonblast_jupyter /bin/bash
jupyter notebook list
```
## Quick Installation
Docker is used for the installation of required software.
```console
docker build -t pythonblast:1.0 .
docker run -dt --name pythonblast_jupyter -v ${PWD}:/blast/applications -p 127.0.0.1:8888:8888/tcp pythonblast:1.0 
```
After container creation run: `docker exec -it pythonblast_jupyter /bin/sh` and activate the [E-Direct](https://www.ncbi.nlm.nih.gov/books/NBK179288/) executables with:
```console
cd ../edirect
./setup.sh -y
get_species_taxids.sh -t 9606
```

If everything is set successfully you should see this output in the container terminal:
`````console
9606
63221
741158
`````
## BLAST

Example commands for NCBIs C++ BLAST suite:

````console
makeblastdb -in prot_1_db.faa -dbtype prot -taxid 1140 -blastdb_version 5
makeblastdb -in prot_2_db.faa -dbtype prot -taxid 1844971 -blastdb_version 5
blastdb_aliastool -dblist 'prot_1_db.faa prot_2_db.faa' -dbtype prot -title combined_db -out combined_db
blastp -query test.faa -db combined_db -out blast_out.table -outfmt "6 qseqid sseqid evalue bitscore qgi sgi sacc pident nident mismatch gaps qcovhsp staxids sscinames scomnames sskingdoms  stitle"

makeblastdb -in test.faa -dbtype prot -taxid_map acc_to_taxid.table -blastdb_version 5 -parse_seqids
blastp -query .\test.faa -db test.faa -out blast_out.table -outfmt "6 qseqid sseqid evalue bitscore qgi sgi sacc pident nident mismatch gaps qcovhsp staxids sscinames scomnames sskingdoms  stitle"

````

## E-Direct
EDirect search commands for symbiosis, EPS and organismic interactions. Search field and tags for pubmed are listed [here](https://pubmed.ncbi.nlm.nih.gov/help/#search-tags). Some examples regarding the linking process of EDirect commands.
````Shell
esearch -db pubmed -query "EPS membrane formation" | elink -target protein | efilter -organism curvibacter | efetch -format fasta > curvibacter_eps_proteins.faa

esearch -db pubmed -query "genes involved in symbiosis" | efetch format abstract > abstracts_genes_involved_in_symbiosis.list.txt

esearch -db pubmed -query "genes involved in symbiosis" | elink -target protein | efilter -organism curvibacter | efetch -format fasta > curvibacter_symbiosis_gene_candidates.faa

esearch -db pubmed -query "organismic interactions" | elink -target protein | efilter -organism eubacteria | efetch -format fasta > eubacteria_organismic_interactions.faa
````
More advanced filtering with `xtract`.
````Shell
esearch -db pubmed -query "microbiome [MAJR:TIAB] AND symbiosis [MAJR:TIAB] AND review [PT]" | efetch -format docsum | xtract -pattern DocumentSummary -sep '\t' -element Id PubDate Source Author Title ELocationID > symbiosis_reviews.txt

esearch -db pubmed -query "symbiosis[MAJR:TIAB] OR organismic+interactions[MAJR:TIAB] OR inter-kingdom[MAJR:TIAB] OR EPS[MAJR:TIAB]" | \
elink -target protein | \
efilter -organism "Curvibacter+sp.+AEP1-3" -source refseq | \
efetch -format fasta > curvibacter_symbiosis_gene_candidates.faa


esearch -db assembly -query "Curvibacter" | efetch -format docsum
````
