# download SRA files conviniently using fastq-dump
esearch -db sra -query PRJNA509906  | efetch --format runinfo | cut -d ',' -f 1 | grep SRR | xargs -n 1 -P 12 fastq-dump --split-files --gzip --skip-technical
