wget ftp://igenome:G3nom3s4u@ussd-ftp.illumina.com/Escherichia_coli_K_12_MG1655/NCBI/2001-10-15/Escherichia_coli_K_12_MG1655_NCBI_2001-10-15.tar.gz
curl -L -o escherichia_coli_k12_mg1655.m130404_014004_sidney_c100506902550000001823076808221337_s1_p0.1.fastq.xz http://sourceforge.net/projects/wgs-assembler/files/wgs-assembler/wgs-8.0/datasets/escherichia_coli_k12_mg1655.m130404_014004_sidney_c100506902550000001823076808221337_s1_p0.1.fastq.xz/download 
tar -xzvf Escherichia_coli_K_12_MG1655_NCBI_2001-10-15.tar.gz 
unxz escherichia_coli_k12_mg1655.m130404_014004_sidney_c100506902550000001823076808221337_s1_p0.1.fastq.xz 
head -n 16000 escherichia_coli_k12_mg1655.m130404_014004_sidney_c100506902550000001823076808221337_s1_p0.1.fastq > ecoli.4k.fastq
cp Escherichia_coli_K_12_MG1655/NCBI/2001-10-15/Sequence/WholeGenomeFasta/genome.fa .

