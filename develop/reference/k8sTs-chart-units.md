---
description: Rancher Observability
---

# Supported units for charts

This page contains all units supported by charts. For every unit first the description of the unit is mentioned, followed by the name of the unit that should be used in the Rancher Observability APIs. For example to get a value displayed in "Scientific notation" use `sci` as the value for the unit in a metric binding.

The rendering of the unit automatically adjusts to the size of the value. For example if the unit for a chart is `bytes` the value is interpretted as `bytes(IEC)`. A value of `100` will be rendered as `100B`, but a value of `5242880` (`5*1024*1024`) will be shown as `5MiB`.

## Misc
* None: none
* String: string
* Short: short
* Percent (0-100): percent
* Percent (0.0-1.0): percentunit
* Humidity (%H): humidity
* Decibel: dB
* Hexadecimal (0x): hex0x
* Hexadecimal: hex
* Scientific notation: sci
* Locale format: locale
* Pixels: pixel

## Acceleration
* Meters/sec²: accMS2
* Feet/sec²: accFS2
* G unit: accG

## Angle
* Degrees (°): degree
* Radians: radian
* Gradian: grad
* Arc Minutes: arcmin
* Arc Seconds: arcsec

## Area
* Square Meters (m²): areaM2
* Square Feet (ft²): areaF2
* Square Miles (mi²): areaMI2

## Computation
* FLOP/s: flops
* MFLOP/s: mflops
* GFLOP/s: gflops
* TFLOP/s: tflops
* PFLOP/s: pflops
* EFLOP/s: eflops
* ZFLOP/s: zflops
* YFLOP/s: yflops

## Concentration
* parts-per-million (ppm): ppm
* parts-per-billion (ppb): conppb
* nanogram per cubic meter (ng/m³): conngm3
* nanogram per normal cubic meter (ng/Nm³): conngNm3
* microgram per cubic meter (μg/m³): conμgm3
* microgram per normal cubic meter (μg/Nm³): conμgNm3
* milligram per cubic meter (mg/m³): conmgm3
* milligram per normal cubic meter (mg/Nm³): conmgNm3
* gram per cubic meter (g/m³): congm3
* gram per normal cubic meter (g/Nm³): congNm3
* milligrams per decilitre (mg/dL): conmgdL
* millimoles per litre (mmol/L): conmmolL

## Currency
* Dollars ($): currencyUSD
* Pounds (£): currencyGBP
* Euro (€): currencyEUR
* Yen (¥): currencyJPY
* Rubles (₽): currencyRUB
* Hryvnias (₴): currencyUAH
* Real (R$): currencyBRL
* Danish Krone (kr): currencyDKK
* Icelandic Króna (kr): currencyISK
* Norwegian Krone (kr): currencyNOK
* Swedish Krona (kr): currencySEK
* Czech koruna (czk): currencyCZK
* Swiss franc (CHF): currencyCHF
* Polish Złoty (PLN): currencyPLN
* Bitcoin (฿): currencyBTC
* Milli Bitcoin (฿): currencymBTC
* Micro Bitcoin (฿): currencyμBTC
* South African Rand (R): currencyZAR
* Indian Rupee (₹): currencyINR
* South Korean Won (₩): currencyKRW
* Indonesian Rupiah (Rp): currencyIDR
* Philippine Peso (PHP): currencyPHP
* Vietnamese Dong (VND): currencyVND

## Data
* bytes(IEC): bytes
* bytes(SI): decbytes
* bits(IEC): bits
* bits(SI): decbits
* kibibytes: kbytes
* kilobytes: deckbytes
* mebibytes: mbytes
* megabytes: decmbytes
* gibibytes: gbytes
* gigabytes: decgbytes
* tebibytes: tbytes
* terabytes: dectbytes
* pebibytes: pbytes
* petabytes: decpbytes

## Data rate
* packets/sec: pps
* bytes/sec(IEC): binBps
* bytes/sec(SI): Bps
* bits/sec(IEC): binbps
* bits/sec(SI): bps
* kibibytes/sec: KiBs
* kibibits/sec: Kibits
* kilobytes/sec: KBs
* kilobits/sec: Kbits
* mibibytes/sec: MiBs
* mibibits/sec: Mibits
* megabytes/sec: MBs
* megabits/sec: Mbits
* gibibytes/sec: GiBs
* gibibits/sec: Gibits
* gigabytes/sec: GBs
* gigabits/sec: Gbits
* tebibytes/sec: TiBs
* tebibits/sec: Tibits
* terabytes/sec: TBs
* terabits/sec: Tbits
* pibibytes/sec: PiBs
* pibibits/sec: Pibits
* petabytes/sec: PBs
* petabits/sec: Pbits

## Date & time

* Datetime ISO: dateTimeAsIso
* Datetime ISO (No date if today): dateTimeAsIsoNoDateIfToday
* Datetime US: dateTimeAsUS
* Datetime US (No date if today): dateTimeAsUSNoDateIfToday
* Datetime local: dateTimeAsLocal
* Datetime local (No date if today): dateTimeAsLocalNoDateIfToday
* Datetime default: dateTimeAsSystem
* From Now: dateTimeFromNow

## Energy
* Watt (W): watt
* Kilowatt (kW): kwatt
* Megawatt (MW): megwatt
* Gigawatt (GW): gwatt
* Milliwatt (mW): mwatt
* Watt per square meter (W/m²): Wm2
* Volt-ampere (VA): voltamp
* Kilovolt-ampere (kVA): kvoltamp
* Volt-ampere reactive (var): voltampreact
* Kilovolt-ampere reactive (kVAr): kvoltampreact
* Watt-hour (Wh): watth
* Watt-hour per Kilogram (Wh/kg): watthperkg
* Kilowatt-hour (kWh): kwatth
* Kilowatt-min (kWm): kwattm
* Ampere-hour (Ah): amph
* Kiloampere-hour (kAh): kamph
* Milliampere-hour (mAh): mamph
* Joule (J): joule
* Electron volt (eV): ev
* Ampere (A): amp
* Kiloampere (kA): kamp
* Milliampere (mA): mamp
* Volt (V): volt
* Kilovolt (kV): kvolt
* Millivolt (mV): mvolt
* Decibel-milliwatt (dBm): dBm
* Ohm (Ω): ohm
* Kiloohm (kΩ): kohm
* Megaohm (MΩ): Mohm
* Farad (F): farad
* Microfarad (µF): µfarad
* Nanofarad (nF): nfarad
* Picofarad (pF): pfarad
* Femtofarad (fF): ffarad
* Henry (H): henry
* Millihenry (mH): mhenry
* Microhenry (µH): µhenry
* Lumens (Lm): lumens

## Flow
* Gallons/min (gpm): flowgpm
* Cubic meters/sec (cms): flowcms
* Cubic feet/sec (cfs): flowcfs
* Cubic feet/min (cfm): flowcfm
* Litre/hour: litreh
* Litre/min (L/min): flowlpm
* milliLitre/min (mL/min): flowmlpm
* Lux (lx): lux

## Force
* Newton-meters (Nm): forceNm
* Kilonewton-meters (kNm): forcekNm
* Newtons (N): forceN
* Kilonewtons (kN): forcekN

## Hash rate
* hashes/sec: Hs
* kilohashes/sec: KHs
* megahashes/sec: MHs
* gigahashes/sec: GHs
* terahashes/sec: THs
* petahashes/sec: PHs
* exahashes/sec: EHs

## Mass
* milligram (mg): massmg
* gram (g): massg
* pound (lb): masslb
* kilogram (kg): masskg
* metric ton (t): masst

## Length
* millimeter (mm): lengthmm
* inch (in): lengthin
* feet (ft): lengthft
* meter (m): lengthm
* kilometer (km): lengthkm
* mile (mi): lengthmi

## Pressure
* Millibars: pressurembar
* Bars: pressurebar
* Kilobars: pressurekbar
* Pascals: pressurepa
* Hectopascals: pressurehpa
* Kilopascals: pressurekpa
* Inches of mercury: pressurehg
* PSI: pressurepsi

## Radiation
* Becquerel (Bq): radbq
* curie (Ci): radci
* Gray (Gy): radgy
* rad: radrad
* Sievert (Sv): radsv
* milliSievert (mSv): radmsv
* microSievert (µSv): radusv
* rem: radrem
* Exposure (C/kg): radexpckg
* roentgen (R): radr
* Sievert/hour (Sv/h): radsvh
* milliSievert/hour (mSv/h): radmsvh
* microSievert/hour (µSv/h): radusvh

## Rotational Speed
* Revolutions per minute (rpm): rotrpm
* Hertz (Hz): rothz
* Radians per second (rad/s): rotrads
* Degrees per second (°/s): rotdegs

## Temperature
* Celsius (°C): celsius
* Fahrenheit (°F): fahrenheit
* Kelvin (K): kelvin

## Time
* Hertz (1/s): hertz
* nanoseconds (ns): ns
* microseconds (µs): µs
* milliseconds (ms): ms
* seconds (s): s
* minutes (m): m
* hours (h): h
* days (d): d
* duration (ms): dtdurationms
* duration (s): dtdurations
* duration (hh:mm:ss): dthms
* duration (d hh:mm:ss): dtdhms
* Timeticks (s/100): timeticks
* clock (ms): clockms
* clock (s): clocks

## Throughput
* counts/sec (cps): cps
* ops/sec (ops): ops
* requests/sec (rps): reqps
* reads/sec (rps): rps
* writes/sec (wps): wps
* I/O ops/sec (iops): iops
* counts/min (cpm): cpm
* ops/min (opm): opm
* reads/min (rpm): rpm
* writes/min (wpm): wpm

## Velocity
* meters/second (m/s): velocityms
* kilometers/hour (km/h): velocitykmh
* miles/hour (mph): velocitymph
* knot (kn): velocityknot

## Volume
* millilitre (mL): mlitre
* litre (L): litre
* cubic meter: m3
* Normal cubic meter: Nm3
* cubic decimeter: dm3
* gallons: gallons
