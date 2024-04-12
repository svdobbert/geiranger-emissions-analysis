# add year, month, and hour
input$year <- year(input$Datetime_2)
input$month <- month(input$Datetime_2)
input$hour <- hour(input$Datetime_2)

# adjust time (e.g. years to be included)
input <- subset(input, input$year >= firstYear & input$year <= lastYear)
unique(input$year)

# include night and day distinction
input_bymonth <- split(input, input$month)
for(i in seq_along(input_bymonth)) {
    input_bymonth[[i]]$day_night <- rep(day_night[[i]], nrow(input_bymonth[[i]])/24)
}
input <- as.data.frame(do.call(rbind,input_bymonth))
day_night <- input$day_night
old <- c(0:2)
new <- c("night", "twilight", "day")
day_night[day_night %in% old] <- new[match(day_night, old, nomatch = 0)]
input$day_night <- day_night

# rename months
month <- input$month
old <- unique(input$month)
new <- c("Jul", "Aug", "Sep", "Oct", "Nov", "Dec", "Jan", "Feb", "Mar", "Apr", "May", "Jun")
month[month %in% old] <- new[match(month, old, nomatch = 0)]
input$month <- month

# restructure input
site <- c("Geiranger", "Fjordcentre", "Dalen")
elevation <- c("2 m a.s.l.", "90 m a.s.l.", "420 m a.s.l.")
input_restructured <- data.frame(
    PM2.5 = c(input$G_PM2.5, input$C_PM2.5, input$D_PM2.5),
    site = rep(site, each = nrow(input)),
    elevation = rep(site, each = nrow(input)),
    date = rep(input$Datetime_2, 3),
    year = rep(input$year, 3),
    month = rep(input$month, 3),
    hour = rep(input$hour, 3),
    day_night = rep(input$day_night, 3),
    air_pressure = rep(input$AP_00, 3),
    precipitation = rep(input$P_00, 3),
    relative_humidity = rep(input$RH_00, 3),
    radiation00 = rep(input$R_00, 3),
    radiation933 = rep(input$R_09, 3),
    radiation1450 = rep(input$R_14, 3),
    temp00 = rep(input$T_00, 3),
    temp770 = rep(input$T_07, 3),
    temp933 = rep(input$T_09, 3),
    temp1280 = rep(input$T_12, 3),
    temp1450 = rep(input$T_14, 3),
    inversion_ratio = rep(input$IR_Bulk, 3),
    wind_direction_east00 = rep(input$U_WD_00, 3),
    wind_direction_east14 = rep(input$U_WD_14, 3),
    wind_direction_north00 = rep(input$V_WD_00, 3),
    wind_direction_north14 = rep(input$V_WD_14, 3),
    max_wind_speed00 = rep(input$mxWS_00, 3),
    min_wind_speed00 = rep(input$mnWS_00, 3),
    mean_wind_speed00 = rep(input$avWS_00, 3),
    max_wind_speed14 = rep(input$mxWS_14, 3),
    min_wind_speed14 = rep(input$mnWS_14, 3),
    mean_wind_speed14 = rep(input$avWS_14, 3),
    ships = rep(input$Model_PM2.5_All_Ships_Contributors, 3),
    model = rep(input$Model_PM2.5_All_Ships, 3)
)

# get day from date column
input_restructured$day <- as.Date(input_restructured$date,format="%Y-%m-%d")