cd(".")

# activate environment and initiate: 
#] activate .  
#instantiate

# dependencies
using Arrow             # Arrow storage and file format
using CategoricalArrays # similar to the factor type in R
using CSVFiles  # read/write CSV and similar formats
using Downloads         # file downloads
using DataFrames        # versatile tabular data format
using GZip              # utilities for compressed files
using Tar               # tar archive utilities
using MixedModels
using ShiftedArrays
using Printf
using FillArrays
using Dates

import ShiftedArrays: lead, lag

df = DataFrame(load(File(format"CSV", "./input-data/input_full.csv.gz")))

input = DataFrame(
	PM = df[:, "PM2.5"],
	ships = df[:, "all_ships"],
	elevation = df[:, "elevation"],
	datetime = df[:, "date"],
	day_night = df[:, "day_night"],
)

input_sorted = sort!(input, :datetime)

function calculate_lead(df, lead_value, interval)
	result = combine(groupby(df, :elevation),
		"PM" => (x -> lead(x, (lead_value * interval))) => "PM_lead",
		"datetime" => "datetime",
		"ships" => "ships",
		"day_night" => "day_night")
	result.lead = Fill(lead_value, nrow(result))
	result
end

df_lead = calculate_lead(input_sorted, 2, 24)

df_lead = DataFrame(
	elevation = String[],
	PM_lead = [],
	datetime = String[],
	ships = [],
	day_night = String[],
	lead = Int64[])

for i in 0:100
	append!(df_lead, calculate_lead(input_sorted, i, 24))
end
df_lead

# get on- and off-season
df_lead.date = SubString.(df_lead.datetime, 1, 10)
date_format = Dates.DateFormat("yyyy-mm-dd")
df_lead.date = Dates.Date.(df_lead.date, date_format)
df_lead.doy = Dates.dayofyear.(df_lead.date)

function get_seasons(df)
	df.season = replace(df.doy) do s
		r = s < 92 || s > 305 ? 1 : s
		s > 91 && s < 306 ? 2 : r
	end
    df.season = replace(string.(df.season)) do s
		r = s == "1" ? "off-season" : s
		s == "2" ? "on-season" : r
	end
	df
end

df_lead = get_seasons(df_lead)
unique(df_lead.season)

GC.gc() 
# mixed models
form = @formula(PM_lead ~ ships + (ships | lead) );
lm1 = fit(MixedModel, form, df_lead)::MixedModel