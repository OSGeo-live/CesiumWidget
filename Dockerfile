FROM andrewosh/binder-base

USER root

RUN apt-get update && apt-get install -y postgis \
                       postgresql-contrib \
                       postgresql-9.4 \
                       postgresql-client-9.4 \
                       postgresql-contrib-9.4 \
                       postgresql-9.4-postgis-2.1 \
                       ossim-core grass-core

RUN echo "root:root" | chpasswd
RUN echo "main:main" | chpasswd


USER main

RUN conda update conda
RUN conda install anaconda=2.4.1

# install demo support
RUN conda install \
    ipywidgets \
    numpy \
  && pip install \
    czml \
    geocoder

RUN /home/main/anaconda/envs/python3/bin/pip install --upgrade pip
RUN /home/main/anaconda/envs/python3/bin/pip install \
    czml \
    geocoder \
    ipywidgets


#RUN git clone https://github.com/epifanio/CesiumWidget.git --depth=1
RUN git clone  https://github.com/OSGeo-live/CesiumWidget --depth=1


WORKDIR CesiumWidget

RUN python setup.py install
RUN /home/main/anaconda/envs/python3/bin/python setup.py install

# jupyter-pip so crazy. this is cheating, as a real user wouldn't have
# the source checked out...
RUN jupyter nbextension install CesiumWidget/static/CesiumWidget --user --quiet

ADD condalist.txt /tmp/condalist.txt
RUN conda install -y --file /tmp/condalist.txt
RUN conda install -y -n python3 --file /tmp/condalist.txt


ADD condalist-IOOS.txt /tmp/condalist-IOOS.txt
RUN conda install -y -c IOOS --file /tmp/condalist-IOOS.txt
RUN conda install -y -c IOOS -n python3 --file /tmp/condalist-IOOS.txt

ADD getdata.sh /tmp/getdata.sh
RUN /tmp/getdata.sh

COPY GSOC /home/main/notebooks/GSOC

# setup postgresql
USER postgres

# start db and make new user and db (osgeo) listening from all host
RUN /etc/init.d/postgresql start &&\
    psql --command "CREATE USER main WITH SUPERUSER PASSWORD 'main';" &&\
    createdb -O main main

# add naturalhear data into postgis
ADD natualearth.sh /tmp/natualearth.sh
RUN /tmp/natualearth.sh

