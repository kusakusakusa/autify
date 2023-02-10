# docker build -t autify .
# docker run -it autify
# ruby autify.rb https://autify.com/pricing https://www.google.com
FROM ruby:3.2
RUN mkdir /workspace
WORKDIR /workspace/
COPY . /workspace
CMD ["/bin/bash"]
