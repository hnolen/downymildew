# downymildew

This repo contains any downy mildew-related scripts (phylogenetics, pop gen, etc..)


# QDM-010 P. variabilis genome

Created By: Haley Nolen
Last Edited: Mar 06, 2020 12:27 PM

**All files/scripts can be found in premise at: `/mnt/home/poleatewich/hbn1002/pvgenome` and in Box at `Plant pathology lab/Quinoa downy mildew/PhD Experiments/QDM-010/pvgenome`**

---

# Trimmomatic v0.39

- Citation:
    - Bolger, A. M., Lohse, M., & Usadel, B. (2014). Trimmomatic: A flexible trimmer for Illumina Sequence Data. Bioinformatics, btu170.

---

code run in slurm script:

`srun trimmomatic PE -phred33 ./V3_ATTCAGAA-TAATCTTA_L001_R1_001.fastq.gz ./V3_ATTCAGAA-TAATCTTA_L001_R2_001.fastq.gz`

These were the raw reads from genome center

outputs: `paired_R2.fq.gz` `paired_R1.fq.gz` `unpaired_R1.gz` `unpaired_R2.gz` All of these are fastq files!

Github page:

[mossmatters/KewHybSeqWorkshop](https://github.com/mossmatters/KewHybSeqWorkshop/blob/master/FastQC_Trimmomatic.md)

---

# Spades v3.13.1

- Citation:

    [](https://www.liebertpub.com/doi/full/10.1089/cmb.2012.0021)

input: forward and reverse reads from genome center

output: `contigs.fasta` `contigs.paths` `scaffolds.fasta` `scaffolds.paths` `spades.log` (link to log)`spades.output` (link to output)

for options: `spades.py --help`

code run in slurm script:

[`spades.py](http://spades.py/) -1 paired_R1.fq.gz -2 paired_R2.fq.gz -o ~/pvgenome`

---

Github page:

[ablab/spades](https://github.com/ablab/spades)

---

# Quast v4.6.0

- Citation found at:

    [ablab/quast](https://github.com/ablab/quast/blob/master/LICENSE.txt)

usage:

    ./quast.py test_data/contigs_1.fasta \
               test_data/contigs_2.fasta \
            -r test_data/reference.fasta.gz \
            -g test_data/genes.txt \
            -1 test_data/reads1.fastq.gz -2 test_data/reads2.fastq.gz \
            -o quast_test_output

output:

    report.txt      summary table
    report.tsv      tab-separated version, for parsing, or for spreadsheets (Google Docs, Excel, etc)  
    report.tex      Latex version
    report.pdf      PDF version, includes all tables and plots for some statistics
    report.html     everything in an interactive HTML file
    icarus.html     Icarus main menu with links to interactive viewers
    contigs_reports/        [only if a reference genome is provided]
      misassemblies_report  detailed report on misassemblies
      unaligned_report      detailed report on unaligned and partially unaligned contigs
    k_mer_stats/            [only if --k-mer-stats is specified]
      kmers_report          detailed report on k-mer-based metrics
    reads_stats/            [only if reads are provided]
      reads_report          detailed report on mapped reads statistics

---

code in slurm script:

`quast.py ~/pvgenome/spades/contigs.fasta -o ~/pvgenome/quast/output_w_ref -R ~/pvgenome/bwa/p_effusa/genome.fna.gz -G ~/pvgenome/ann_p_effusa.gff.gz`

### March 4, 2020

Ran another quast run without a reference genome or gene annotation

code run in `run_quast.slurm` script:

`quast.py ~/pvgenome/spades/contigs.fasta -o ~/pvgenome/quast/output_no_ref`

- [ ]  Link output files here****

---

Github page:

[ablab/quast](https://github.com/ablab/quast)

# Busco v3.0.0

- Citation:

    BUSCO: assessing genome assembly and annotation completeness with single-copy orthologs. Felipe A. Simão, Robert M. Waterhouse, Panagiotis Ioannidis, Evgenia V. Kriventseva, and Evgeny M. Zdobnov Bioinformatics, published online June 9, 2015 | Abstract | Full Text PDF | doi: 10.1093/bioinformatics/btv351 Supplementary Online Materials: SOM

Mandatory options:

    -o name	Name used for naming output files
    
    -in input_file	Genome assembly / gene set / transcriptome in fasta format
    
    -l lineage	Path to the BUSCO lineage data to be used 
    Example: -l /path/to/arthropoda
    
    -m mode	Mode of analysis 
    Valid options: genome, ogs, trans
    Default: genome

Code run in `poleatewich/hbn1002/pvgenome/busco/run_busco.py` :

    export AUGUSTUS_CONFIG_PATH=/mnt/home/poleatewich/hbn1002/config
    python /mnt/lustre/software/linuxbrew/colsa/Cellar/busco/3.0.0/bin/run_BUSCO.py -i ../spades/scaffolds.fasta -l ./eukaryota_odb10 -o busco_output -m genome

Github page: 

[WenchaoLin/BUSCO-Mod](https://github.com/WenchaoLin/BUSCO-Mod)

---

# Maker - v2.31.9

### March 3, 2020

- Created config files for maker in the `~/pvgenome/maker/` directory using the `maker -CTL` command. Three files were created:

    `maker_bopts.ctl` (this is the config file for blast options)

    `maker_exe.ctl` these are the paths to all of the executables

    `maker_opts.ctl` this is the actual file where you put in all of your options

    - I only changed 3 lines from the default values:

        `genome=~/pvgenome/spades/scaffolds.fasta`

        `protein=~/pvgenome/p_effusa_protein.fa.gz`

        `model_gff=~/pvgenome/ann_p_effusa.gff.gz`

- Then I created a slurm script `~/pvgenome/maker/run_maker.slurm` , with all of the usual stuff and the only actual code for maker is `maker` at the bottom (all of the options are in the actual config file)
- ran `sbatch run_maker.slurm`
    - Got errors saying my genome, protein, and model_gff files don't exist
    - Also got an error that gene models must be in a GFF3 format to use model_gff, I think the file I put in was just GFF

        I changed all of the paths to absolute file paths but then got the following errors in my `.output` file:

            Possible precedence issue with control flow operator at /mnt/lustre/software/linuxbrew/colsa-20171116/Cellar/perl/5.26.1/lib/perl5/site_perl/5.26.1/Bio/DB/IndexedBase.pm line 845.
            STATUS: Parsing control files...
            STATUS: Processing and indexing input FASTA files...
            WARNING: The fasta file contains sequences with names longer
            than 78 characters.  Long names get trimmed by BLAST, making
            it harder to identify the source of an alignmnet. You might
            want to reformat the fasta file with shorter IDs.
            File_name:/mnt/home/poleatewich/hbn1002/pvgenome/p_effusa_protein.fa.gz
            
            
            ------------- EXCEPTION: Bio::Root::Exception -------------
            MSG: FASTA header doesn't match '>(\S+)': >^K   ^E$5<8A><E3><80>M<F4><90><EE>
            
            STACK: Error::throw
            STACK: Bio::Root::Root::throw /mnt/lustre/software/linuxbrew/colsa-20171116/Cellar/perl/5.26.1/lib/perl5/site_perl/5.26.1/Bio/Root/Root.pm:447
            STACK: Bio::DB::Fasta::_calculate_offsets /mnt/lustre/software/linuxbrew/colsa-20171116/Cellar/perl/5.26.1/lib/perl5/site_perl/5.26.1/Bio/DB/Fasta.pm:195
            STACK: Bio::DB::IndexedBase::_index_files /mnt/lustre/software/linuxbrew/colsa-20171116/Cellar/perl/5.26.1/lib/perl5/site_perl/5.26.1/Bio/DB/IndexedBase.pm:699
            STACK: Bio::DB::IndexedBase::index_file /mnt/lustre/software/linuxbrew/colsa-20171116/Cellar/perl/5.26.1/lib/perl5/site_perl/5.26.1/Bio/DB/IndexedBase.pm:527
            STACK: Bio::DB::IndexedBase::new /mnt/lustre/software/linuxbrew/colsa-20171116/Cellar/perl/5.26.1/lib/perl5/site_perl/5.26.1/Bio/DB/IndexedBase.pm:404
            STACK: FastaDB::_safe_new /mnt/oldhome/software/linuxbrew/colsa-20171116/Cellar/maker/2.31.9/libexec/bin/../lib/FastaDB.pm:204
            STACK: FastaDB::new /mnt/oldhome/software/linuxbrew/colsa-20171116/Cellar/maker/2.31.9/libexec/bin/../lib/FastaDB.pm:45
            STACK: GI::build_fasta_index /mnt/oldhome/software/linuxbrew/colsa-20171116/Cellar/maker/2.31.9/libexec/bin/../lib/GI.pm:1894
            STACK: /mnt/lustre/software/linuxbrew/colsa/bin/maker:536
            -----------------------------------------------------------
            --> rank=NA, hostname=node138.rcchpc
            --> rank=NA, hostname=node138.rcchpc

        - [ ]  Ask Toni what the heck to do

    NOTE: apparently maker actually ran, output a directory `scaffolds.maker.output` , but I don't think it ran all the way because there are only log files for the config files.

---

Good Maker tutorial/resource:

[http://weatherby.genetics.utah.edu/MAKER/wiki/index.php/MAKER_Tutorial_for_WGS_Assembly_and_Annotation_Winter_School_2018](http://weatherby.genetics.utah.edu/MAKER/wiki/index.php/MAKER_Tutorial_for_WGS_Assembly_and_Annotation_Winter_School_2018)

Github page:

[In-depth description of running MAKER for genome annotation.](https://gist.github.com/darencard/bb1001ac1532dd4225b030cf0cd61ce2)

Using samtools to view my P. variabilis contigs aligned with the P. effusa reference

    samtools view -h -b aln-pe.sam > aln-pe_mapped.bam
    samtools view -q 10 <input># filter by quality
    [hbn1002@login01 pvgenome]$ samtools sort effusa_var_contigs_aln.bam -o effusa_var_contigs_sorted.bam
    [hbn1002@login01 pvgenome]$ samtools index effusa_var_contigs_sorted.bam

## Questions for Toni:

- [ ]  What to look for after quast?
- [x]  What to look for after busco?
    - busco percentage in summary file
