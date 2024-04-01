FROM python:3.10-bullseye

RUN apt update -y && apt upgrade -y && apt install -y poppler-utils imagemagick libopenblas-dev ghostscript sqlite3 sudo gnupg vim

RUN python -m pip install --upgrade pip

# install MongoDB
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
RUN touch /etc/apt/sources.list.d/mongodb-org-5.0.list &&\
    echo "deb http://repo.mongodb.org/apt/debian buster/mongodb-org/5.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list &&\
    apt update &&\
    apt install -y mongodb-org
RUN mkdir -p /data/db

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN pip3 install -r requirements.txt

RUN mkdir -p /usr/src/app/data
RUN mkdir -p /usr/src/app/data/{pdf,txt,thumbs,tmp}
RUN echo $RANDOM | md5sum | head -c 20 > data/secret_key.txt
RUN sqlite3 as.db < schema.sql
#RUN ln -s data/txt data/pdf data/db.p data/tfidf_meta.p data/sim_dict.p data/user_sim.p data/tfidf.p data/search_dict.p data/as.db data/tmp data/secret_key.txt . && ln -s ../data/thumbs static/

RUN chmod +x /usr/src/app/start.sh &&\
    chmod +x /usr/src/app/init_image.sh

RUN /usr/src/app/init_image.sh

EXPOSE 8080
EXPOSE 27017

ENTRYPOINT ["/usr/src/app/start.sh"]
