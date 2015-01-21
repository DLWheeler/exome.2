rule markdups:
     input:  "{x}.sorted.{Y}"
     output: out = "{x}.dedup.sorted.{Y}",
             metrics = "{x}.sorted.{Y}.txt"
     params: markdups=config['bin']['MARKDUPS']
     shell:  "{params.markdups} I={input} O={output.out} M={output.metrics} REMOVE_DUPLICATES=TRUE AS=TRUE"

