rule coverage_qc:
    input: "{x}"+ext
    output: hist = "{x}.coverage.done"
    shell:  "cat {input} |cut -f1,2,4 > out && Rscript QC/coverage.R {wildcards.x};touch {wildcards.x}.coverage.done"

