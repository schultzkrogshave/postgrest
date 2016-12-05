# Create ubuntu image with Postgrest installed

#FROM ubuntu:16.10
#FROM robcult/postgrest:0.1
FROM robcult/postgrest

ADD postgrest.config /

# That will expose on port 3000
EXPOSE 3000

CMD postgrest -c postgrest.config
