using Pkg

Pkg.activate(".")

Pkg.add("Arrow")             # Arrow storage and file format
Pkg.add("CategoricalArrays") # similar to the factor type in R
Pkg.add("CSVFiles")  # read/write CSV and similar formats
Pkg.add("Downloads")         # file downloads
Pkg.add("DataFrames")        # versatile tabular data format
Pkg.add("GZip")              # utilities for compressed file
Pkg.add("Tar")               # tar archive utilities
Pkg.add("MixedModels")
Pkg.add("ShiftedArrays")
Pkg.add("Printf")
Pkg.add("FillArrays")
Pkg.add("Dates")