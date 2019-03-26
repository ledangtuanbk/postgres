FROM postgres:9.6
# Take the war and copy to webapps of tomcat
ENV TZ=Asia/Ho_Chi_Minh
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
COPY unaccent.rules /usr/share/postgresql/9.6/tsearch_data/unaccent.rules
RUN apt-get update && apt-get install -y \
  nano \
  net-tools \
  openssh-client \
  telnet 
