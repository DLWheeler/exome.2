rule fastq:
     input:
     output: config['FILEDIR']+"{sample}_1.fastq.gz",
             config['FILEDIR']+"{sample}_2.fastq.gz"
#     log:    config['lpath']+"{sample}.fastqc.log"
     message: "Executing Fastq Rule."
     threads: 1
     version: "1.0"
     shell:  config['rules']['fastq'][mode]
