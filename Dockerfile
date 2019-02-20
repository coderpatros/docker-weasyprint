FROM alpine:latest

RUN set -ex && \
    # WeasyPrint dependencies
    # https://weasyprint.readthedocs.io/en/stable/install.html#linux
    apk add --no-cache gcc musl-dev jpeg-dev zlib-dev libffi-dev cairo-dev pango-dev gdk-pixbuf-dev && \
    # fonts
    apk add --no-cache msttcorefonts-installer fontconfig && \
    update-ms-fonts && \
    fc-cache -f && \
    # requirements for wsgi.py
    # apk add --no-cache bash cairo pango py3-cffi py3-pillow py-lxml && \
    apk add --no-cache python3-dev py3-gunicorn py3-flask && \
    pip3 install weasyprint && \
    mkdir /myapp

WORKDIR /myapp

COPY wsgi.py /myapp/wsgi.py

EXPOSE 8080
ENTRYPOINT ["gunicorn", "--bind", "0.0.0.0:8080", "wsgi:app"]
