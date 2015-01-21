rule checkqc:
      input:  "{x}.recal.realign.fin.dedup.sorted.bam"
      output: cov= "{x}.uniqcov",
              covall = "{x}_covall.txt",
              stat = "{x}_covstat.txt",
              ism = "{x}.insert_size_metrics",
              hist = "{x}_PIChist.pdf",
              flag = "{x}.flagstat.txt",
              tbl="{x}.recal.tbl"
      params: covcalc = config['bin']['COVCALC'],
              covfreq = config['bin']['COVFREQ'],
              gatk=config['bin']['GATK'],
              genome=config['references']['GENOME'],
              picard2=config['bin']['PICARD2'],
              pichist=config['bin']['PICHIST'],
              readdist = config['bin']['READDIST'],
              refflat=config['references']['REFFLAT']
      shell:  "coverageBed -abam {input} -hist -b {params.refflat} > {output.cov}; \
              perl {params.covcalc} {output.cov} {output.stat}; \
              grep 'all' {output.cov} > {output.covall}; \
              echo 'source(\"{params.covfreq}\"); RunData(file2 = \"{output.covall}\")' | R --vanilla; \
              {params.picard2} INPUT={input} REFERENCE_SEQUENCE={params.genome} OUTPUT={output.ism} HISTOGRAM_FILE={output.hist}; \
              R --vanilla < {params.pichist} --args {output.ism} {output.hist} {input}; \
              samtools flagstat {input} > {output.flag}; \
              {params.gatk} -T ReadLengthDistribution -I {input} -R {params.genome} -o {output.tbl}; \
              echo 'source(\"{params.readdist}\"); RunHist(file = \"{output.tbl}\")' | R --vanilla;"
