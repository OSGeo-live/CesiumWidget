#!/usr/bin/env bash
USERHOME=/home/main

DATA_FOLDER=$USERHOME/notebooks/data
GRASS_DATA_FOLDER=$DATA_FOLDER/grass6data/
BASE_URL="http://grass.osgeo.org/sampledata/"
NE2_DATA_FOLDER="$DATA_FOLDER/natural_earth2"

mkdir -p $DATA_FOLDER
mkdir -p $GRASS_DATA_FOLDER
mkdir -p $NE2_DATA_FOLDER

wget "http://grass.osgeo.org/sampledata/spearfish_grass60data.tar.gz"
tar -zxvf spearfish_grass60data.tar.gz
rm -rf spearfish_grass60data.tar.gz
mv spearfish60 $DATA_FOLDER/grass6data

wget -c --progress=dot:mega http://download.osgeo.org/livedvd/data/natural_earth2/all_10m_20.tgz
tar xzf all_10m_20.tgz
for tDir in ne_10m_*; do
   mv $tDir/* $NE2_DATA_FOLDER
   rm -rf $tDir
done


RFILE=HYP_50M_SR_W_reduced.zip
wget -c --progress=dot:mega \
   "http://download.osgeo.org/livedvd/data/natural_earth2/$RFILE"
unzip "$RFILE"

rm "$RFILE"

mv HYP_* "$NE2_DATA_FOLDER"

cd "$NE2_DATA_FOLDER"

for SHP in *.shp; do \
    S=`basename $SHP .shp`
    ogrinfo -sql "CREATE SPATIAL INDEX ON $S" $SHP;
done

rm -rf /home/main/*gz

touch /home/main/.grassrc6

echo "GISDBASE: /home/main/notebooks/data/grass6data" >> /home/main/.grassrc6                                                                                     
echo "LOCATION_NAME: spearfish60" >> /home/main/.grassrc6                                                                                                         
echo "MAPSET: PERMANENT" >> /home/main/.grassrc6                                                                                                                  
echo "GRASS_GUI: text" >> /home/main/.grassrc6



##################################
# Download netCDF datasets:
#

mkdir -p  /home/main/notebooks/data/netcdf
mkdir netcdf; cd netcdf

t_netcdf_files="
README_netCDF_samples.txt
rx5dayETCCDI_yr_MIROC5_historical_r2i1p1_1850-2012.nc
rx5dayETCCDI_yr_MIROC5_historical_r2i1p1_1850-2012.nc.txt
rx5dayETCCDI_yr_MIROC5_rcp45_r2i1p1_2006-2100.nc
rx5dayETCCDI_yr_MIROC5_rcp45_r2i1p1_2006-2100.nc.txt
txxETCCDI_yr_MIROC5_historical_r2i1p1_1850-2012.nc
txxETCCDI_yr_MIROC5_historical_r2i1p1_1850-2012.nc.txt
txxETCCDI_yr_MIROC5_rcp45_r2i1p1_2006-2100.nc
txxETCCDI_yr_MIROC5_rcp45_r2i1p1_2006-2100.nc.txt
"
for n in $t_netcdf_files; do
	wget -c -N --progress=dot:mega http://download.osgeo.org/livedvd/data/netcdf/$n
done

mv * /home/main/notebooks/data/netcdf/
cd ..
rm -rf netcdf

# Cape Cod SRTM and LANDSAT  (this part is disble because of disc space issue)

mkdir -p $DATA_FOLDER/landsat/
DATA_URL="http://download.osgeo.org/livedvd/data/ossim/"
BASENAME="p011r031_7t19990918_z19_nn"
for BAND in 10 20 30 ; do
    # LANDSAT
    wget --progress=dot:mega "$DATA_URL/ossim_data/${BASENAME}$BAND.tif" \
         --output-document="$DATA_FOLDER/landsat/${BASENAME}$BAND.tif"
done

wget --progress=dot:mega "$DATA_URL/ossim_data/SRTM_fB03_p011r031.tif" \
         --output-document="$DATA_FOLDER/landsat/SRTM_fB03_p011r031.tif"

wget  --progress=dot:mega "http://download.osgeo.org/livedvd/data/ossim/ossim_data/ossim-dem-color-table-template.kwl" \
         --output-document="$DATA_FOLDER/landsat/ossim-dem-color-table-template.kwl"