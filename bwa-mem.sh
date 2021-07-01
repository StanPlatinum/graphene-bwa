#!/bin/bash

for i in {1..80}
do
echo "removing aln-$i.sam";
rm -f /mnt/graphene-dida-bwa/pr/out/aln-$i.sam;
echo "generating aln-$i.sam";
graphene-sgx bwa mem -k25 -o /mnt/graphene-dida-bwa/pr/out/aln-$i.sam /mnt/graphene-dida-bwa/work/ref_80/mref-$i.fa /mnt/graphene-dida-bwa/pr/mreads-$i.fa;
done
