FROM gdiener/ansible:latest

USER root

RUN mkdir -p /etc/ansible

RUN apk add --no-cache \
    nano \
    fping \
    curl \
    zsh \
    py-pip

RUN pip install mdv

COPY ansible/ansible.cfg /etc/ansible/ansible.cfg
COPY ansible/hosts /etc/ansible/hosts
COPY files/id_rsa* /home/ansible/.ssh/
COPY steps /home/ansible/steps
COPY files/use-step.sh /bin/use-step
COPY files/.zshrc /home/ansible/.zshrc

RUN chown -R ansible:ansible /home/ansible/ && \
    chmod 644 /home/ansible/.ssh/id_rsa.pub && \
    chmod 600 /home/ansible/.ssh/id_rsa

USER ansible

CMD /bin/zsh