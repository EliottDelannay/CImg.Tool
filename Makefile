LIB_XWINDOWS=-I/usr/X11R6/include -L/usr/X11R6/lib -lX11
LIB_CIMG=-I../CImg -Wall -W -ansi -pedantic -Dcimg_use_vt100 -lpthread -lm -fopenmp
LIB_NETCDF= -I../NetCDF/include/ -lnetcdf_c++ -L../NetCDF/lib/ -lnetcdf 
CPP= g++ -O0 -Wall -W 

all: write read version

version: writeCImgNetCDF_test.cpp readCImgNetCDF_test.cpp CImg_NetCDF.h ../CImg/CImg.h
	./writeCImgNetCDF_test --version > VERSIONS
	./readCImgNetCDF_test --version >> VERSIONS
	grep cimg_version ../CImg/CImg.h --color | head -n 2 | tail -n 1 | sed 's/#define //' >> VERSIONS
	cat VERSIONS | sort -u -r

write: writeCImgNetCDF_test.cpp CImg_NetCDF.h  useCImg.h
	$(CPP) writeCImgNetCDF_test.cpp $(LIB_CIMG) $(LIB_NETCDF) -o writeCImgNetCDF_test && ./writeCImgNetCDF_test --help --version

read: readCImgNetCDF_test.cpp CImg_NetCDF.h  useCImg.h
	$(CPP) readCImgNetCDF_test.cpp $(LIB_CIMG) $(LIB_NETCDF) -o readCImgNetCDF_test && ./readCImgNetCDF_test --help --version

write_run:
	./writeCImgNetCDF_test && ncdump -h CImgNetCDF_CImgTest.nc && ncdump -h  CImgNetCDF_CImgListTest.nc

read_run:
	ncdump -h CImgNetCDF_cimgListTest.4d-1.nc && ./readCImgNetCDF_test

clear:
	rm -f CImgNetCDF_CImgTest.nc
	sync

clean: clear
	rm -f writeCImgNetCDF_test readCImgNetCDF_test

