awk 'BEGIN {FS = "\t" ; OFS = "\n"} {header = $0 ; getline seq ; getline qheader ; getline qseq ; if (length(seq) <= 2000) {print header, seq, qheader, qseq}}' < input.fastq > filtered.fastq
