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


#RUN git clone https://github.com/petrushy/CesiumWidget.git --depth=1
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

COPY GSOC /home/main/notebooks/GSOC

RUN wget http://epinux.com/data.tar.gz
RUN tar xvf data.tar.gz