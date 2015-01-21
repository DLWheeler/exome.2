rule varscan:
       input:  lambda wildcards: config['pairs'][wildcards.x][0]+ext,
               lambda wildcards: config['pairs'][wildcards.x][1]+ext
       output: snp="{x}.snp",
               indel= "{x}.indel",
               snpvcf="{x}.snp.vcf",
               indelvcf="{x}.indel.vcf"
       params: varscan=config['bin']['VARSCAN'],
               snpvcf="{x}.snp",indelvcf="{x}.indel"
       message: "****VARSCAN****"
       shell:  "{params.varscan} somatic {input[0]} {input[1]} --output-snp {output.snp} --output-indel {output.indel} --tumor-purity 0.85 --strand-filter 1;{params.varscan} somatic {input[0]} {input[1]} --output-snp {params.snpvcf} --output-indel {params.indelvcf} --output-vcf 1 --tumor-purity 0.85 --strand-filter 1"

