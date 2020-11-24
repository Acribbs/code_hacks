# How to split a file into smaller sub folders
# Identified this one from wanting to split fast5 files into
# sub dirs to then basecall using guppy
# https://askubuntu.com/questions/584724/split-contents-of-a-directory-into-multiple-sub-directories

# Will split a file into sub dirs with 500 samples per dir
i=0;
for f in *;
do
    d=dir_$(printf %03d $((i/500+1)));
    mkdir -p $d;
    mv "$f" $d;
    let i++;
done
