#!/bin/sh

get_icon_day() {
    case $1 in
        210) echo  ;;		# light thunderstorm
        211) echo  ;;		# thunderstorm
        500) echo  ;;		# light rain
        721) echo  ;;		# haze
        800) echo  ;;		# clear sky
        801) echo  ;;		# few clouds
        802) echo  ;;		# scattered clouds
        803) echo  ;;		# broken clouds
        804) echo  ;;		# overcast clouds
        *) return 1;;
    esac
}

get_icon_night() {
    case $1 in
        210) echo  ;;		# light thunderstorm
        211) echo  ;;		# thunderstorm
        500) echo  ;;		# light rain
        800) echo  ;;		# clear sky
        801) echo  ;;		# few clouds
        802) echo  ;;		# scattered clouds
        803) echo  ;;		# broken clouds
        804) echo  ;;		# overcast clouds
        *) return 1;;
    esac

}

get_icon() {
    case $1 in
        d) fn=get_icon_day;;
        n) fn=get_icon_night;;
    esac

    if $fn $2; then
        return
    fi

    case $2 in
        200) echo  ;;		# thunderstorm with light rain
        201) echo  ;;		# thunderstorm with rain
        202) echo  ;;		# thunderstorm with heavy rain
        210) echo  ;;		# light thunderstorm
        211) echo  ;;		# thunderstorm
        212) echo  ;;		# heavy thunderstorm
        221) echo  ;;		# ragged thunderstorm
        230) echo  ;;		# thunderstorm with light drizzle
        231) echo  ;;		# thunderstorm with drizzle
        232) echo  ;;		# thunderstorm with heavy drizzle
        300) echo  ;;		# light intensity drizzle
        301) echo  ;;		# drizzle
        302) echo  ;;		# heavy intensity drizzle
        310) echo  ;;		# light intensity drizzle rain
        311) echo  ;;		# drizzle rain
        312) echo  ;;		# heavy intensity drizzle rain
        313) echo  ;;		# shower rain and drizzle
        314) echo  ;;		# heavy shower rain and drizzle
        321) echo  ;;		# shower drizzle
        500) echo   ;; 	# light rain
        501) echo  ;;		# moderate rain
        502) echo  ;;		# heavy intensity rain
        503) echo  ;;		# very heavy rain
        504) echo  ;;		# extreme rain
        511) echo  ;;		# freezing rain
        520) echo  ;;		# light intensity shower rain
        521) echo  ;;		# shower rain
        522) echo  ;;		# heavy intensity shower rain
        531) echo  ;;		# ragged shower rain
        600) echo  ;;		# light snow
        601) echo  ;;		# snow
        602) echo  ;;		# heavy snow
        611) echo  ;;		# sleet
        612) echo  ;;		# shower sleet
        615) echo  ;;		# light rain and snow
        616) echo  ;;		# rain and snow
        620) echo  ;;		# light shower snow
        621) echo  ;;		# shower snow
        622) echo  ;;		# heavy shower snow
        701) echo  ;;		# mist
        711) echo  ;;		# smoke
        721) echo  ;;		# haze
        741) echo  ;;		# fog
        762) echo  ;;		# volcanic ash
        781) echo  ;;		# tornado
        # 731) echo  ;;		# sand, dust whirls
        # 751) echo  ;;		# sand
        # 761) echo  ;;		# dust
        # 771) echo  ;;		# squalls
        *) echo  ;;
    esac
}

CITY=""

SYMBOL="°"
ICON_COL="147a82"

if [ -n "$CITY" ]; then
    if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
        CITY_PARAM="id=$CITY"
    else
        CITY_PARAM="q=$CITY"
    fi

    weather=$(curl -sf "https://api.openweathermap.org/data/2.5/weather?appid=$OPENWEATHERMAP_API_KEY&$CITY_PARAM&units=$UNITS")
else
    location="$(curl -X POST -sf "https://www.googleapis.com/geolocation/v1/geolocate?key=$GOOGLE_GEOLOCATE_API_KEY")"

    if [ -n "$location" ]; then
        location_lat="$(echo "$location" | jq '.location.lat')"
        location_lon="$(echo "$location" | jq '.location.lng')"

        weather=$(curl -sf "https://api.openweathermap.org/data/2.5/weather?appid=$OPENWEATHERMAP_API_KEY&lat=$location_lat&lon=$location_lon&units=metric")
    fi
fi

if [ -n "$weather" ]; then
    # weather_desc=$(echo "$weather" | jq -r ".weather[0].description")
    weather_temp=$(echo "$weather" | jq '.main.temp' | cut -d "." -f 1)
    weather_code=$(echo "$weather" | jq -r '.weather[0].id')
    time_of_day=$(echo "$weather" | jq -r '.weather[0].icon | split("") | last')

    icon=$(get_icon "$time_of_day" "$weather_code")

    echo "%{F#$ICON_COL}$icon%{F-}  $weather_temp$SYMBOL"
else
    echo "%{F#$ICON_COL}%{F-}"
fi
